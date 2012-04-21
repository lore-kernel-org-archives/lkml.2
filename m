Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2DULt7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:49:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2DULt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:49:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 12/17] ARM clps711x: Simple optimise debug_macro by removing one NOP
Date: Sat, 21 Apr 2012 11:49:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <1334999490-27177-13-git-send-email-shc_work@mail.ru> <201204211118.23857.arnd@arndb.de>
In-Reply-To: <201204211118.23857.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204211149.47404.arnd@arndb.de>
X-Provags-ID: V02:K0:IpeUdQd882xCFgZX8fv2lxOssMEyQscq1IxAFkbxXaG
 Whi9Hk3R6ja4vZX8pnG7lYGBSP4XwzKJZf8h/A5zIiaMXuqDYz
 PHSXPER8MDEnssS4Midoo1nqcNmpXcgC499PA31CasQ+3F7dKh
 i06e6jQ+QyaUIYClWnqSkP4Ank7UsAuT5zggaqa4RXo6/aFIWJ
 GlVDXbaLOPvnMIRd05LaS6XVMl9qVERURL+kazHjV44IYN/zsJ
 hIvhzWTlB24pSxATL8Ult47kgScIXG2fpXF+cmlOpf2u4lj7K9
 Jl+D4Smo2w+QBt4cTsSyRfpUnmxfLbAzP5ccehdZpZno0ONWnJ
 AS4N5YUp/T+8PKRQ7enc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2012, Arnd Bergmann wrote:
> 
> On Saturday 21 April 2012, Alexander Shiyan wrote:
> > 
> >                 .macro  addruart, rp, rv, tmp
> > -#ifndef CONFIG_DEBUG_CLPS711X_UART2
> > -               mov     \rp, #0x0000    @ UART1
> > -#else
> > -               mov     \rp, #0x1000    @ UART2
> > +#ifdef CONFIG_DEBUG_CLPS711X_UART2
> > +               mov     \rp, #0x1000    @ Add offset for UART2 base reg
> >  #endif
> >                 orr     \rv, \rp, #CLPS711X_VIRT_BASE
> >                 orr     \rp, \rp, #CLPS711X_PHYS_BASE
> 
> This looks wrong at first sight. Is rp guaranteed to be zero when calling
> the macro? Am I misreading this? Sorry my ARM assembly skill is still horrible.

Ah, Russell was faster to point out the same problem. Well I'm glad that
I sometimes read the assembly correctly then ;-)

	Arnd
