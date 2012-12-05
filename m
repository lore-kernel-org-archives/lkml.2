Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2LERYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:24:10 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33236 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2LERYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:24:08 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
Date: Wed, 5 Dec 2012 18:24:05 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc7-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <201212051718.44017.Martin@lichtvoll.de> <20121205163303.GG18885@thunk.org> (sfid-20121205_181332_034477_2335FA49)
In-Reply-To: <20121205163303.GG18885@thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201212051824.05621.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Dezember 2012 schrieb Theodore Ts'o:
> On Wed, Dec 05, 2012 at 05:18:43PM +0100, Martin Steigerwald wrote:
> > Dave provided technical reasons.
> > 
> > First in the patch description and then in:
> > 
> > https://lkml.org/lkml/2012/11/26/700
> 
> There were no technical reasons.  We are only reserving a bit.  And
> different file systems don't support all of the various different
> fallocate flags already --- for example, not all file systems support
> the punch system call.
> 
> Yes, I could create an entrely new ioctl() that looks just like
> fallocate, but supports the extra bit, just so that Dave and others
> don't have to be offended about the existence of that extra bit ---
> but Linus (and others) have considered ioctl()'s evil, since there is
> no type checking, and it's just silly to create a separate interface
> just because somebody doesn't think some other file system shouldn't
> implement a particular feature --- especially since it's not like
> we're have any kind of shortage of bits in the fallocate field.

Thanks for explaining your technical view about this. I appreciate it.

> Heck, I probably have more to complain about with the inode flags
> field, which were originally created specifically for ext2/3/4, and
> which has since been grabbed for use by other file systems, including
> btrfs.  You haven't heard me kvetching because btrfs has grabbed
> btrfs-specific inode flags for nocow and notail... no one even bother
> to try to get it past the fs-devel shed painting crew before *those*
> bits were allocated --- and I am absolutely fine with that.

Thats no technical reason – thats exactly the process / patch review stuff 
Linus does not seem to give a shit about at least with this topic.

That aside I wondered about that inode flags in earlier days already. At 
some time chattr +i worked with XFS and then it only worked in Ext3. 
Before that I thought that chattr stuff would work with all filesystems.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
