Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2L0Jvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:51:43 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:47199 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2L0Jvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <20121227082724.GA11775@zuhnb712.ap.bm.net>
References: <20121227082724.GA11775@zuhnb712.ap.bm.net>
Date: Thu, 27 Dec 2012 10:51:40 +0100
X-Google-Sender-Auth: -zm_ffBeIEKQiycwgMzbpV4_lf0
Message-ID: <CAMuHMdWbyrDaaV5TWiEafEpjuscoGKXKKYzNBw_CSSWYLbNaPQ@mail.gmail.com>
Subject: Re: What does ISA/PCI really mean to ARM architecture?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Woody Wu <narkewoody@gmail.com>
Cc: kernelnewbies@kernelnewbies.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 9:27 AM, Woody Wu <narkewoody@gmail.com> wrote:
> Can a peripheral chip that claims to be ISA or PCI device be used in a
> ARM based embedded system?  For these kind of chips, I only concern
> about the planar kind of devices, means they are not on a dedicated
> expansion card.
>
> From hardware point of view, to attach a ISA or PCI planar chip, is
> there any requirement need to fulfill on a ARM bard?
>
> From Linux driver point of view, what are needed to support an ISA or
> PCI driver in ARM architecture?  More important, is ISA or PCI device a
> platform device?  If not, how to add these kind of devices in my board
> definition?

An ISA device is typically a platform device. For ARM, which uses device trees,
this means you define it in the device tree.

A PCI device is not a platform device, as devices on a PCI bus can be
probed automatically. The PCI host bridge is typically a platform device,
though, so it it should be in your device tree.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
