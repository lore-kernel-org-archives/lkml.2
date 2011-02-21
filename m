Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1BUOtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:49:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64850 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab1BUOtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:49:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Linn <John.Linn@xilinx.com>
Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Date: Mon, 21 Feb 2011 15:48:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        jamie@jamieiles.com
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <201102210936.42098.arnd@arndb.de> <c3cdf33d-2163-4417-bc64-7637f5c211e0@VA3EHSMHS021.ehs.local>
In-Reply-To: <c3cdf33d-2163-4417-bc64-7637f5c211e0@VA3EHSMHS021.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102211548.36296.arnd@arndb.de>
X-Provags-ID: V02:K0:ePAzMR9T/ErHLLZkrXnCPif83tInTxUPNx2n2+NOlag
 D8TuDYI9F9A77CKVtUcfmnmFT6ZLtibeZ3KLlQyLXI9Q1F3VeT
 rT+MveBPvZ4GOAgeVcvCiRngvO4BG2JSqUBV0Blta3Vnu1EuJy
 LjmeQkeZwsgy/PmX0dLPj+MDsPhnoNc5mFOtbAan55AdVdSRKb
 ylOCGZRdtfPU5Vg5qoucw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 February 2011, John Linn wrote:
> > It would be better if you could avoid introducing new uses of
> > CLOCK_TICK_RATE, because that will have to be removed before we can
> > move to a real multi-platform kernel. For instance, you can put
> > PERIPHERAL_CLOCK_RATE in a hardware specific header and put a bogus
> > definition for CLOCK_TICK_RATE into timex.h
> 
> Hi Arnd,
> 
> I can remove the use of it from my timer code, but I still see
> CLOCK_TICK_RATE 
> being used in linux/jiffies.h.
> 
> I tried removing it and got build errors.  Am I missing something there?
> 

You still need to have some definition for CLOCK_TICK_RATE to make
the jiffies code compile, but the actual value no longer matters.

Traditionally, this was the i386-style PIT timer frequency of 11.93 MHz
for some things and the actual timer frequency for other things.
The timer code tries to correct the jiffies value based on difference
between the intended HZ frequency (100, 250 or 1000) and the actual
on (something very close to that, but not exact).

You can e.g. set it to (100 * HZ) to make something up that won't
hurt in that calculation.

	Arnd
