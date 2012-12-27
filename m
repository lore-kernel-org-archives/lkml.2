Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2L0OTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:19:35 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:61381 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2L0OTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:19:32 -0500
Subject: Re: What does ISA/PCI really mean to ARM architecture?
From: anish kumar <anish198519851985@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Woody Wu <narkewoody@gmail.com>
Cc: kernelnewbies@kernelnewbies.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CAMuHMdWbyrDaaV5TWiEafEpjuscoGKXKKYzNBw_CSSWYLbNaPQ@mail.gmail.com>
References: <20121227082724.GA11775@zuhnb712.ap.bm.net>
	 <CAMuHMdWbyrDaaV5TWiEafEpjuscoGKXKKYzNBw_CSSWYLbNaPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Dec 2012 19:49:19 +0530
Message-ID: <1356617960.5433.32.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-27 at 10:51 +0100, Geert Uytterhoeven wrote:
> On Thu, Dec 27, 2012 at 9:27 AM, Woody Wu <narkewoody@gmail.com> wrote:
> > Can a peripheral chip that claims to be ISA or PCI device be used in a
> > ARM based embedded system?  For these kind of chips, I only concern
> > about the planar kind of devices, means they are not on a dedicated
> > expansion card.
> >
> > From hardware point of view, to attach a ISA or PCI planar chip, is
> > there any requirement need to fulfill on a ARM bard?
arm AFAIK is only used in embedded system but ISA/PCI buses are
generally part of 'big systems' and most of the times it refers to x86
PC.
> >
> > From Linux driver point of view, what are needed to support an ISA or
> > PCI driver in ARM architecture?  More important, is ISA or PCI device a
> > platform device?  If not, how to add these kind of devices in my board
> > definition?
AFAIK, Platform device is just a way to add a particular driver whose
probe can't be called at runtime.Mostly platform device is part of
system on chip.
PCI devices probe function will be called by the PCI bus as and when it
detects any activity on the bus.So you don't need PCI device to be  a
platform device.
> 
> An ISA device is typically a platform device. For ARM, which uses device trees,
Don't know much about ISA device to comment on this but people familiar
with this can enlighten us as to the reason why it is platform device in
detail.
> this means you define it in the device tree.
> 
> A PCI device is not a platform device, as devices on a PCI bus can be
> probed automatically. The PCI host bridge is typically a platform device,
> though, so it it should be in your device tree.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


