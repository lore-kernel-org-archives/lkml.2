Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0DAVCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:02:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:36045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0DAVCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:02:41 -0400
Message-ID: <4BB50938.9040000@kernel.org>
Date: Thu, 01 Apr 2010 13:59:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Peter Jones <pjones@redhat.com>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] ibft, x86: Change reserve_ibft_region() to find_ibft_region()
References: <4BB3FFE4.4010909@kernel.org> <20100401201206.GA19462@andromeda.dapyr.net>
In-Reply-To: <20100401201206.GA19462@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 01:12 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 31, 2010 at 07:07:32PM -0700, Yinghai Lu wrote:
>>
>>
>> So arch code could decide the way to reserve the ibft.
>>
>> And We should reserve ibft as early as possible, instead of BOOTMEM stage,
>> in case the table is in RAM range and is not reserved by BIOS.
> 
> What test vehicle did you use to find this bug?

code review for CONFIG_NO_BOOTMEM

reserve_bootmem() should only be used for converting entries reserved by reserved_early()

so When we are using CONFIG_NO_BOOTMEM, reserve_bootmem() is killed.

> 
> 
> .. snip..
>> +	if (size)
>> +		reserve_early_overlap_ok(addr, addr + size, "ifbt");
> 							     ^^^^ - ibft
thanks, will change it.

Yinghai
