Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0K2T52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:57:28 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab0K2T51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:57:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=U/TO30Peg5qQIDfie2KNn6yN4GSx0HBHPrSB2IAjJ7IrcUA9fIzC0vbyp6xHhmzrfv
         FXFd3zShB15M/uwMjHN+BmRgWuNhXadwp28ZhZvUAf/K0v2wFF97Z6U5ZyilY+Mh8Kg4
         7t+fNBRgsiFlJtf70YRMWrMA5mrlj1U4MnOoY=
Message-ID: <4CF405A3.9030205@gmail.com>
Date: Mon, 29 Nov 2010 21:57:23 +0200
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011282056.17389.arnd@arndb.de> <4CF3CF33.20407@gmail.com> <20101129193246.GB20761@n2100.arm.linux.org.uk>
In-Reply-To: <20101129193246.GB20761@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 09:32 PM, Russell King - ARM Linux wrote:
> On Mon, Nov 29, 2010 at 06:05:07PM +0200, Paulius Zaleckas wrote:
>> No he really should NOT use readl/writel. The ONLY difference
>> between readl/writel and __raw_readl/__raw_writel is endianess
>> conversion. __raw_*l is not doing it. Which to use depend only
>> on HW.
>
> Wrong.  readl/writel have barriers too to guarantee ordering between
> device accesses and memory accesses.  (device accesses are already
> ordered with respect to themselves.)  __raw variants do not
> guarantee the relative ordering between memory accesses and device
> accesses.

#ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
#define __iormb()		rmb()
#define __iowmb()		wmb()
#else
#define __iormb()		do { } while (0)
#define __iowmb()		do { } while (0)
#endif

CONFIG_ARM_DMA_MEM_BUFFERABLE is NOT defined in this case.
I don't see any other barriers.
readl does endianess conversion. What to do if you don't need it?
Do it one more time?
