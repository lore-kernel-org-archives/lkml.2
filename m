Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2A1OlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 09:41:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33431 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822Ab2A1OlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 09:41:18 -0500
X-Sasl-enc: dwQ7FvQWRplY2e//FX2Yhg4c1q/VEavz8Lwmb/omjxMH 1327761678
Date: Sat, 28 Jan 2012 12:41:14 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, mmarek@suse.cz
Subject: Re: Ioctl warning for a partition
Message-ID: <20120128144114.GB22008@khazad-dum.debian.net>
References: <20120126223037.GE28368@quack.suse.cz>
 <CA+55aFwkRhsdAYwP-S5_qPkRX=dMSnxv5Ow1ULaSJjKe3aTy2w@mail.gmail.com>
 <4F21E828.8090502@msgid.tls.msk.ru>
 <20120127192817.GB25348@khazad-dum.debian.net>
 <4F23CC53.4040304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F23CC53.4040304@redhat.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jan 2012, Paolo Bonzini wrote:
> On 01/27/2012 08:28 PM, Henrique de Moraes Holschuh wrote:
> >Does that fix still need to be backported to -stable?
> >
> >Linux v3.0.18 + Debian stable userspace (mdadm v3.1.4) causes this on
> >boot (when mdadm runs in the initramfs):
> >
> >mdadm: sending ioctl 1261 to a partition!
> >mdadm: sending ioctl 1261 to a partition!
> >mdadm: sending ioctl 1261 to a partition!
> >mdadm: sending ioctl 1261 to a partition!
> >mdadm: sending ioctl 1261 to a partition!
> >mdadm: sending ioctl 1261 to a partition!
> >mdadm: sending ioctl 1261 to a partition!
> >mdadm: sending ioctl 1261 to a partition!
> >mdadm: sending ioctl 800c0910 to a partition!
> >mdadm: sending ioctl 800c0910 to a partition!
> 
> The warnings are intended; the kernel will behave as before they
> were introduced.  I'm monitoring reports and looking at them as they
> come in.  They are harmless as long as the ioctls have always
> failed, and so far this has always been the case.  As soon as we are
> reasonably certain, the warnings will go away.

I am aware of that.  It is just that a previous message in this thread
implied the ioctls from mdadm had already been dealth with (i.e.  should
not be issuing warnings anymore).

After it has been tested enough in mainline, please make sure to direct
all patches related to this issue to stable@v.k.o.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
