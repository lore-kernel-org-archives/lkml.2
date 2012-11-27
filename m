Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2K0NoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:44:08 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48636 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2K0NoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:44:07 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
Date: Tue, 27 Nov 2012 14:44:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc6-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Dave Chinner <david@fromorbit.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121126115345.19977e46@pyramind.ukuu.org.uk> <20121126211200.GI6434@dastard> (sfid-20121127_001638_373244_611CF8E2)
In-Reply-To: <20121126211200.GI6434@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211271444.04002.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 26. November 2012 schrieb Dave Chinner:
> On Mon, Nov 26, 2012 at 11:53:45AM +0000, Alan Cox wrote:
> > > It's not like there is any shortage of flag bits, so what's the
> > > harm of reserving the bit?
> > 
> > Why not just reserve a small group of bits for fs private use in that
> > case - for any fs.
> 
> Flawed - one bit, one function for all filesystems, otherwise the
> same binary could behave very differently on different filesystems.
> 
> Besides, we already have a mechanism for adding filesystem specific
> interfaces. It's called an ioctl.  That's what it's there for - a
> free-form extensible interface that can be wholly defined and
> contained in the out-of-tree patch.
> 
> Most filesystems implement ioctls for their own specific
> functionality, including for one-off preallocation semantics (e.g.
> XFS_IOC_ZERO_RANGE). There is no reason why ext4 can't do the same
> thing and we can drop the whole issue of having to modify a syscall
> API with magic, undocumented flag bits with unpredictable
> behaviour....
> 
> ext4 is not a special snowflake that allows developers to bend rules
> whenever they want. If the ext4 developers want to support out of
> tree functionality for their filesystem, then they can do it within
> their filesystem via ioctls like everyone else does.

I do not develop for the kernel, just test here a bit, there a bit… and I 
didn´t read the previous discussions about this patch…

… but I think I can follow this argument of yours, Dave.

And Ted, this does not appear to be screaming to me.

So why no ioctl?

And what functionality is this about anyway? Sometimes I read in some 
kernel source and I am happy that sometimes can understood some of it. 
Reading "this is used for some magic Google or Tao Bao do with their 
filesystem" would decrease my chance to understand whats going on there. 
Not quite approbiate for an open source kernel, I think.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
