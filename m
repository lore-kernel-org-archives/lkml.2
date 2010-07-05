Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0GEPFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 11:05:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab0GEPFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 11:05:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <C80B6032-0FB2-4D63-B940-3FE86B52992B@dilger.ca>
References: <C80B6032-0FB2-4D63-B940-3FE86B52992B@dilger.ca> <20100701235727.19035.84584.stgit@warthog.procyon.org.uk> <20100701235738.19035.21536.stgit@warthog.procyon.org.uk>
To: Andreas Dilger <adilger@dilger.ca>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] xstat: Implement a requestable extra result to procure some inode flags [ver #4]
Date: Mon, 05 Jul 2010 16:05:40 +0100
Message-ID: <4964.1278342340@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger <adilger@dilger.ca> wrote:

> I would say this should be a full-fledged member of struct xstat.  I think
> they are fairly standard (available on many filesystems today), and
> requiring an ioctl to access them is unpleasant.

Remember: adding them to xstat and kstat will use up three extra 64-bit words
of stack at least if ecryptfs.

Are they used often enough to justify this?

> Yuck on the names.  Why not stick with the "UF_" and "SF_" prefixes?

Firstly, this is a quick and dirty example, primarily because I'd like someone
to take a look at the mechanism.

Secondly, because the flags I've added don't have UF_ and SF_ variants within
Linux.

> Since we don't need to keep _binary_ compatibility with these flag values
> (only name portability) we can use the same flag values as the FS_*_FL
> definitions in fs.h.

No, you can't, because Linux doesn't have separate S and U variants.

However, I'd be quite happy to just use the FS_*_FL, perhaps plus a couple of
flags, and have userspace munge together the BSD-compatible st_flags.  To that
end, could we rearrange i_flags to match the ioctl?

David
