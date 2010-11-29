Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab0K2PC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:02:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64690 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab0K2PC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:02:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
Date: Mon, 29 Nov 2010 16:02:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011282056.17389.arnd@arndb.de> <alpine.LNX.2.00.1011291316560.11926@localhost.localdomain>
In-Reply-To: <alpine.LNX.2.00.1011291316560.11926@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011291602.54932.arnd@arndb.de>
X-Provags-ID: V02:K0:L/J7bpmruIApjVUQGRwa3Xdr8RKFJsr+y5vQrgoLTuH
 QL6TtA+FJEGMLTXucsAAZTRee35O3moGsfgrb2tMw71XzY2rOI
 b3lNV6r2GiYlOH5Rfbxzs5v6lR1Apja7guFlWihoyH8LFeM9Mc
 EIOj0wzPTRWGbJL+iddTNudpdNalyUpTcXzf6Ad6Y2BWy8aBVo
 rIJvuemBnXWAALnSnvtIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 November 2010, Hans Ulli Kroll wrote:
> > 
> > This looks wrong in multiple ways:
> > 
> > * resources are physical addresses, not virtual addresses
> > * GEMINI_PCI_IO_BASE is an address in memory space, so it
> >   needs to be IORESOURCE_MEM, not IORESOURCE_IO. You can
> >   also register the IORESOURCE_IO resource, but that would
> >   be .start=PCIBIOS_MIN_IO, .end=IO_SPACE_LIMIT.
> > * IO_SPACE_LIMIT is larger than the I/O window, which can
> >   cause overflows. Setting it to 0xffff is generally enough.
> > 
> 
> So I must remove these lines ??
>         }, {
>                 .virtual        = IO_ADDRESS(GEMINI_PCI_IO_BASE),
>                 .pfn            = __phys_to_pfn(GEMINI_PCI_IO_BASE),
>                 .length         = SZ_512K,
>                 .type           = MT_DEVICE,
>         },
> These are from arch/arm/mach-gemini/mm.c

No, these look right, just fix the issues I mentioned, i.e.
the definition of IO_SPACE_LIMIT and the resource registration.

	Arnd
