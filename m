Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0F3KWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0F3KWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:22:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <B82FC7EE-93D2-4D86-906D-5D6AFA502709@dilger.ca>
References: <B82FC7EE-93D2-4D86-906D-5D6AFA502709@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
To: Andreas Dilger <adilger@dilger.ca>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, smfrench@gmail.com,
       jlayton@redhat.com, mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 11:22:17 +0100
Message-ID: <29802.1277893337@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger <adilger@dilger.ca> wrote:

> Note that when ext4 is mounted with the "i_version" option that the
> i_version field is also updated on regular files, for use by NFSv4.  See,
> for example, ext4_mark_iloc_dirty().
> 
> I had a hard time finding this, even though I knew it was there somewhere,
> because it isn't modifying "i_version" directly, but rather calling a helper
> function inode_inc_iversion().

Ah, okay.  Thanks!

> It probably makes sense to always return i_version, unless it is 0.

I didn't want to return it if it wasn't supported on the nominated file as
that may give a false sense of coherency.

David
