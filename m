Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1GRToM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:44:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42329 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248Ab1GRToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:44:10 -0400
Subject: Re: [PATCH] init: Support mounting devices from kernel command line
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <CAOJsxLFEBknf8m5k6XOG=by_-avWT5P+ScoBBHfO0sgZbo_kSA@mail.gmail.com>
References: <1310979967-13470-1-git-send-email-levinsasha928@gmail.com>
	 <CAOJsxLG9h_L8x6-W67bMT1ObQKc=ZoLUKO8ocY4QQs=0rhw5ZQ@mail.gmail.com>
	 <4E2423C4.6090906@msgid.tls.msk.ru>
	 <CAOJsxLFEBknf8m5k6XOG=by_-avWT5P+ScoBBHfO0sgZbo_kSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 14:44:06 -0500
Message-ID: <1311018246.3531.32.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 15:27 +0300, Pekka Enberg wrote:
> On Mon, Jul 18, 2011 at 3:15 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
> >>> In /tools/kvm we are interested in such feature to allow us to automatically
> >>> mount user home directory using virtio-9p from the host to the guest
> >>> filesystem under '/hostfs'.
> >
> > Can't the same be done within initramfs just as easy?
> >
> > Long time ago when initramfs first appeared the plan was to,
> > more or less, move all that mounting and root= handling
> > functionality to userspae, and here we're adding more
> > to kernel.  To me that sounds backwards...
> 
> Well, we can currently boot distro images using custom kernel combined
> with distro initramfs. I'm not sure how we can inject our mount point
> to initramfs as easily.

Actually, I think it can.  An initramfs is designed as an effective root
booting system that runs from /sbin/init, does it's stuff like driver
loading and device finding, mounts the real root and pivots to it before
executing /sbin/init.

It strikes me, therefore, that it's fairly easy to insert another initrd
at the beginning of that process, so you alter the kernel to boot with
virt_initrd as the initramfs.  It would prepare all your mount points
(or muck with the parameters so they'd get mounted by the next initrd)
and load any virt drivers, then take the next initrd into a tempfs,
pivot to it and exec /sbin/init.

That would seem to work without needing any kernel patches at all.

James

> I don't think it's backwards progress but then again, I don't really
> use initramfs or modules for that matter so maybe I'm just old
> fashioned.


