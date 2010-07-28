Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0G1HOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:14:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43838 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0G1HOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:14:11 -0400
Message-ID: <4C4FD85C.2090603@kernel.org>
Date: Wed, 28 Jul 2010 00:12:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 31/31] memblock: Add memblock_find_in_range()
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>	 <1279822864-17154-32-git-send-email-yinghai@kernel.org> <1280295415.1970.245.camel@pasglop> <4C4FC95F.6040806@kernel.org> <4C4FD04B.5090503@zytor.com>
In-Reply-To: <4C4FD04B.5090503@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C4FD8A6.01DD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 11:38 PM, H. Peter Anvin wrote:
> On 07/27/2010 11:08 PM, Yinghai Lu wrote:
>>
>> for example: 
>> high/low allocation, from first kernel to kexec second kernel, always work fine except system with Qlogic card.
>> because Qlogic card is using main RAM as EFT etc for card's FW log trace. second kernel have not idea that those RAM
>>  is used by first kernel for that purpose. that the CARD still use that between two kernels.
>> second kernel could have crash it try to use those ram.
>>
> 
> Uhm, no.  That's a bug in the Qlogic driver not shutting the card down
> cleanly.  Hacking around that in memory allocation order is braindamaged
> in the extreme.  kexec *cannot* be safe in any way if we don't shut down
> pending DMA, and what you describe above is DMA.
> 

the problem is later if the user hit the problem, it will be called "Regression" after bisecting to the memblock/x86 changes.
because low/high does work before.

BTW, that design from qlogic to save log in RAM is not good one, they may save some cents for the ram in card.

other vendors seems put log/trace in the ram on card.

Thanks

Yinghai
