Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2LERzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:55:19 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56472 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2LERzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:55:16 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate UAPI
Date: Wed, 5 Dec 2012 18:55:14 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc7-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <201212051824.05621.Martin@lichtvoll.de> <20121205173415.GI18885@thunk.org> (sfid-20121205_183744_503438_7239BD23)
In-Reply-To: <20121205173415.GI18885@thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201212051855.14996.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 5. Dezember 2012 schrieb Theodore Ts'o:
> On Wed, Dec 05, 2012 at 06:24:05PM +0100, Martin Steigerwald wrote:
> > > Heck, I probably have more to complain about with the inode flags
> > > field, which were originally created specifically for ext2/3/4, and
> > > which has since been grabbed for use by other file systems,
> > > including btrfs.  You haven't heard me kvetching because btrfs has
> > > grabbed btrfs-specific inode flags for nocow and notail... no one
> > > even bother to try to get it past the fs-devel shed painting crew
> > > before *those* bits were allocated --- and I am absolutely fine
> > > with that.
> > 
> > Thats no technical reason – thats exactly the process / patch review
> > stuff Linus does not seem to give a shit about at least with this
> > topic.
> 
> Exactly; just as Dave's complaint is not technical.

For me the ioctl argument looked like a technical argument which you 
answered to now.

And I noted that about the patch review aspects there seem to be quite 
different opinions. I tend to agree with Dave there.

> > That aside I wondered about that inode flags in earlier days already.
> > At some time chattr +i worked with XFS and then it only worked in
> > Ext3. Before that I thought that chattr stuff would work with all
> > filesystems.
> 
> Historically, they were created only for ext2/3/4 file systems.  Over
> time, other file systems have used it as a common interface.  It's for
> historical reasons that it's still an ioctl, as opposed to a system
> call.  For ext2/3/4 the inode flags is actually the on-disk encoding,
> not just the userspace ABI.  For other file systems, it might be just
> the ABI, or it might also be something that they use for their on-disk
> encoding.

Thanks for your detailed explaination.

> Because it's the on-disk encoding, when btrfs uses extra bits for its
> btrfs-specific inode flags, it means that I need to avoid using those
> bits in ext4, if it's a flag that needs to also be exposed via
> chattr/lsattr.  That being said, you'll note that unlike Dave, I have
> **not** thrown a hissy fit when btrfs grabbed bits from the inode
> field, even though quite a bit more bits allocated for the inode flags
> than the fallocate flags.

I do not think this that these kind of comparisons lead to anything 
useful. Cause other have done it is no reason for me doing it.

> P.S.  The main reason why it would have been better for btrfs
> developers to have consulted me is that they also depend on
> lsattr/chattr, and those programs are part of e2fsprogs.  Since no one
> told me about the nocow flag when it first went into the kernel, I
> didn't add it to e2fsprogs until relatively recently --- with the
> result that Ubuntu Lucid doesnt have a version of chattr which
> supports the nocow flag.  (Not a big deal, I just have to convince
> Canoncal to upgrade to a newer version of e2fsprogs.)  So I only get
> annoyed when some btrfs users complain about the lack of support in
> chattr, when the main reason why there was no support at least at
> first was no one bothered to ask me to add support; it was not because
> I had anything against btrfs.  As soon as I found out about the nocow
> flag, I added support to chattr and lsattr and pushed out a new
> release of e2fsprogs.

Which would be an argument for patch review via mailing list and CC´ing 
everyone involved. Cause then you would have known and the patch review 
process would likely have lead to avoid the technical issue the end user 
has had in the first place.

IMO exactly just the non-technical argument, Dave has made, beside his IMO 
technical arguments.

So regardless of the outcome of the review process, it may be that the bit 
goes in or not, the process has some importance here. Even if in the end 
you as the Ext4 maintainer decide that the bit goes in *after* the review 
process, after having read the acks / nacks and their explainations.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
