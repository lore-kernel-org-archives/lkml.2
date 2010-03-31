Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab0CaMX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:23:27 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:35955 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0CaMXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=UN1CrAyNZRLrBWN2aMB1hQBb4CSxu89OTAZryAG//vufpUtoZxKUOb9r+e2Z2DgK2t
         swrZCAyy/c3GMtm1Ql7cBJ97GWeQcO3OjWV9fREoKa6B0IrvlR27PrTT3Yr4lSQ+IUah
         DpKIvIsZQ6HaXxID11hyixcs8InGl2+bJ3ANM=
Date: Wed, 31 Mar 2010 09:23:15 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: r8169 with 64bit DMA is broken
Message-ID: <20100331092315.1a5ac86a@gmail.com>
In-Reply-To: <51f3faa71003291915g7a51ee18q8bc64a0ab7023114@mail.gmail.com>
References: <20100329050515.7b0993a7@gmail.com>
 <51f3faa71003291915g7a51ee18q8bc64a0ab7023114@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 29 Mar 2010 20:15:47 -0600
Robert Hancock <hancockrwd@gmail.com> escribió:
> That sounds similar to a previous report.. Can you CC the thread on
> linux-kernel (if you've seen it)?

Sorry, I am not subscribed.

> Also, what does dmesg show when loading the driver? There should be a
> string showing the chip version, something like this:
<...>

r8169 0000:05:00.0: eth0: RTL8102e at 0xffffc900100be000,
00:26:b9:a0:33:86, XID 04e00000 IRQ 28

Then, after initialization, it shows two "link up" messages, and that's
all it reports. It's a nice blackhole :P.

> On Mon, Mar 29, 2010 at 2:05 AM, Ismael Luceno
> <ismael.luceno@gmail.com> wrote:
> > On 2.6.33 it worked fine, but then I decided to upgrade to
> > 2.6.34-rc2 and it simply didn't detected the carrier correctly
> > anymore (it was like if the cable was always plugged...).
> >
> > After a short inspection, the obvious offender was commit
> > 353176888386d9025062a12dcec08d49af10cf2c.
> >
> > I tried with use_dac=0, but it didn't work (I had no time to
> > investigate it further), but after reverting the commit it worked
> > again.
> >
> > The system is a Dell Inspiron mini 1012, lspci reports:
> > 05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> > RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
> > Subsystem: Dell Device 041a Flags: bus master, fast devsel, latency
> > 0, IRQ 28 I/O ports at 2000 [size=256]
> >        Memory at f0f20000 (64-bit, prefetchable) [size=4K]
> >        Memory at f0f10000 (64-bit, prefetchable) [size=64K]
> >        [virtual] Expansion ROM at f0f40000 [disabled] [size=128K]
> >        Capabilities: <access denied>
> >        Kernel driver in use: r8169
> >        Kernel modules: r8169
> >
