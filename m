Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0GFXpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 19:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab0GFXpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 19:45:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100706230312.GB25018@dastard>
References: <20100706230312.GB25018@dastard> <20100706001032.GA25018@dastard> <20100705154319.31193.56706.stgit@warthog.procyon.org.uk> <29431.1278423623@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Rearrange i_flags to be consistent with FS_IOC_GETFLAGS
Date: Wed, 07 Jul 2010 00:45:25 +0100
Message-ID: <5045.1278459925@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> wrote:

> I'd prefer generic flags are not dependent on fixed values from a
> specific filesystem several layers down the storage stack.

They're not so dependent.  They're based on the FS_IOC_[GS]ETFLAGS ioctl which
even XFS translates its flags for.  These ioctl flags must now remain
invariant.  Whilst they might have originated as Ext2/3/4 flags, they're now
independent of that.

> Also, if the problem you are trying to solve is overhead of calculating the
> flags for stat() on RISC architectures, then I'd argue that XFS is just as
> important target for such an optimisation because it is widely used in small
> ARM and MIPS based NAS appliances....

This can be argued one way or another, however aligning i_flags with something
would probably be an improvement somewhere.  Most of what I deal with is Ext3/4
based, and BTRFS-based is likely to become important too.

David
