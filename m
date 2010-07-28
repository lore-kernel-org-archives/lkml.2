Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0G1UAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:00:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33168 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab0G1UAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:00:06 -0400
Message-ID: <4C508BF4.9050901@zytor.com>
Date: Wed, 28 Jul 2010 12:58:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>	 <1279822864-17154-32-git-send-email-yinghai@kernel.org>	 <1280295415.1970.245.camel@pasglop> <4C4FC95F.6040806@kernel.org>	 <4C4FD04B.5090503@zytor.com> <1280336548.30808.489.camel@mulgrave.site>	 <4C506E9B.4070501@zytor.com> <1280340633.30808.583.camel@mulgrave.site> <4C507728.3000207@zytor.com> <4C5084A6.9060303@kernel.org>
In-Reply-To: <4C5084A6.9060303@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 12:27 PM, Yinghai Lu wrote:
>>
>> Yinghai, do you have any more detail, or know who would?  Also copying
>> the Qlogic Infinipath maintainer email...
> 
> when I was debug memblock with x86, found the strange crash when high/low.
> then use kexec with "memtest" in command line, and the early memtest does find
> some bad memory. 
> 
> then I add more print about EPT physical address for first kernel,
> it does show that range is used by qla driver in first kernel.
> I built all needed drivers in kernel so can pxeboot the kernel on all test platforms easily.
> 

[Cc: Andrew Vasquez, who seems to have written the offending code,
checkin df613b96077cee826b14089ae6e75eeabf71faa3.]

The question is still open why this particular DMA activity was not shut
down before the kexec.  I'm not familiar with how non-crashdump kexec
idles the hardware, but it obviously better do so.

	-hpa
