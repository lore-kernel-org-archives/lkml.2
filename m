Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0DOHcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:32:32 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10143 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757430Ab0DOHc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:32:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAFZdxks7p+/x/2dsb2JhbACcUr4ghQ4E
Message-ID: <4BC6C0FE.1000701@call-direct.com.au>
Date: Thu, 15 Apr 2010 17:32:14 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: Anders Larsen <al@alarsen.net>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ian McDonnell <ian@brightstareng.com>, Nicolas Pitre <nico@fluxnic.net>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Fix Oops with Atmel SPI
References: <4BC56F21.6040909@call-direct.com.au> <1271231840l.5270l.0l@i-dmzi_al.realan.de>
In-Reply-To: <1271231840l.5270l.0l@i-dmzi_al.realan.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anders,

Anders Larsen wrote:
> Hi Iwo,
> 
> On 2010-04-14 09:30:41, Iwo Mergler wrote:
>> I wouldn't recommend that. MTD erase blocks are 64K or more. In a typical
>> embedded system you will not be able to kmalloc that much memory after
>> a few day's of operation - the page pool gets fragmented.
> 
> the original problem occurs with SPI flashes, which typically have a much
> smaller erase block size (and it only occurs when they are driven by an Atmel
> SoC SPI controller, hence the #ifdefs)
> 
>> A possibly better approach is to arrange for that memory to get allocated
>> at driver start time.
> 
> The buffer in question is indeed allocated _once_ (at the first write
> operation to the device) and only deallocated when the device is unmounted,
> so allocating it at driver load time wouldn't make much difference IMHO.
> 

I'm sorry, I thought you were somewhere else in the MTD source.
The bad block handling code for NAND also has a full erase block
allocation, which happens during runtime. 

You are correct in that the mount time allocation should be
safe, for most systems.

Best regards,

Iwo

