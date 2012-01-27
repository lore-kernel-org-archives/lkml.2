Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2A0T2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:28:24 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43278 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773Ab2A0T2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:28:22 -0500
X-Sasl-enc: V/UafIkyYa6EqAabKqsgNPHkF/TqI8tfwhQLBjl1lqDM 1327692501
Date: Fri, 27 Jan 2012 17:28:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, mmarek@suse.cz
Subject: Re: Ioctl warning for a partition
Message-ID: <20120127192817.GB25348@khazad-dum.debian.net>
References: <20120126223037.GE28368@quack.suse.cz>
 <CA+55aFwkRhsdAYwP-S5_qPkRX=dMSnxv5Ow1ULaSJjKe3aTy2w@mail.gmail.com>
 <4F21E828.8090502@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F21E828.8090502@msgid.tls.msk.ru>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael!

On Fri, 27 Jan 2012, Michael Tokarev wrote:

> On 27.01.2012 03:01, Linus Torvalds wrote:
> > On Thu, Jan 26, 2012 at 2:30 PM, Jan Kara <jack@suse.cz> wrote:
> >>
> >> It's easy enough to silence the warning the same way as
> >> CDROM_GET_CAPABILITY since the ioctl is safe but it's not so simple for
> >> 32-bit userspace.  MTIOCGET32 is defined only in fs/compat_ioctl.c so we
> >> cannot easily add it to scsi_verify_blk_ioctl(). Any opinion how to cleanly
> >> solve this? The only idea I had was to define compat structures and ioctl
> >> numbers in a special header and use it both in fs/compat_ioctl.c and in
> >> block/scsi_ioctl.c.
> > 
> > I suspect we can just remove the warning entirely - once we've gotten
> > enough coverage with the -rc kernels that people (me in particular)
> > are happy that no normal load really needs it, and returning an error
> > is fine.
> > 
> > So I don't really consider the warning to be something long-term - I
> > wanted it to make sure that some random binary in some odd
> > distribution wouldn't break in mysterious ways that would take a lot
> > of debugging to find. And so that we really know what we end up
> > blocking in practice.
> > 
> > I'm not sure how good the -rc kernel coverage is, but I think it's
> > good enough that we can drop the warning before doing a real 3.3
> > release. And I don't think the stable kernel versions ever got that
> > warning printout, did they? That would be great for coverage, of
> > course, if they did.
> 
> They did, 3.0 and 3.2.
> 
> For example, 3.0.18:
> 
> [  610.488489] kvm: sending ioctl 5326 to a partition!
> [  610.488540] kvm: sending ioctl 80200204 to a partition!
> 
> mdadm ioctls reported in various places apparently got fixed by
> ENOTTY/ENOIOCTLCMD change.

Does that fix still need to be backported to -stable?

Linux v3.0.18 + Debian stable userspace (mdadm v3.1.4) causes this on
boot (when mdadm runs in the initramfs):

mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 800c0910 to a partition!
mdadm: sending ioctl 800c0910 to a partition!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
