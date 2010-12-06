Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab0LFKww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 05:52:52 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62796 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0LFKwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 05:52:51 -0500
Message-ID: <4CFCC048.4030408@ru.mvista.com>
Date: Mon, 06 Dec 2010 13:51:52 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Paulius Zaleckas <paulius.zaleckas@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com>	<201011282056.17389.arnd@arndb.de> <4CF3CF33.20407@gmail.com> <201011291745.22566.arnd@arndb.de>
In-Reply-To: <201011291745.22566.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-11-2010 19:45, Arnd Bergmann wrote:

>>> The I/O ordering is probably not what you think it is.
>>> There is no ordering guarantee between __raw_writel and
>>> spin_lock/spin_unlock, so you really should be using
>>> readl/writel.

>> No he really should NOT use readl/writel. The ONLY difference
>> between readl/writel and __raw_readl/__raw_writel is endianess
>> conversion. __raw_*l is not doing it. Which to use depend only
>> on HW.

> There are many differences between readl and __raw_readl, including

> * __raw_readl does not have barriers and does not serialize with
>    spinlocks, so it breaks on out-of-order CPUs.
> * __raw_readl does not have a specific endianess, while readl is
>    fixed little-endian,

    I know I'm late but readl()/writel() are CPU-endian, not LE.

WBR, Sergei
