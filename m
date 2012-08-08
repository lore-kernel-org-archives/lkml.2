Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2HHNTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:19:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39166 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab2HHNTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:19:04 -0400
Message-ID: <5022673A.7060407@ti.com>
Date: Wed, 8 Aug 2012 09:18:50 -0400
From: Cyril Chemparathy <cyril@ti.com>
Reply-To: <cyril@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040045360.5231@xanadu.home> <50219C45.7030601@ti.com> <alpine.LFD.2.02.1208080106500.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208080106500.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/12 01:56, Nicolas Pitre wrote:
> On Tue, 7 Aug 2012, Cyril Chemparathy wrote:
[...]
>> u32 arm_check[] = {
>> 	0xe2810041, 0xe2810082, 0xe2810f41, 0xe2810f82, 0xe2810e41,
>> 	0xe2810e82, 0xe2810d41, 0xe2810d82, 0xe2810c41, 0xe2810c82,
>> 	0xe2810b41, 0xe2810b82, 0xe2810a41, 0xe2810a82, 0xe2810941,
>> 	0xe2810982, 0xe2810841, 0xe2810882, 0xe2810741, 0xe2810782,
>> 	0xe2810641, 0xe2810682, 0xe2810541, 0xe2810582, 0xe2810441,
>> };
>
> Instead of using this array you could let the assembler do it for you
> like this:
>
> asm (" \n\
> 	.arm \n\
> arm_check: \n\
>          .set shft, 0 \n\
>          .rep 12 \n\
>          add     r1, r2, #0x81 << \shft \n\
>          .set shft, \shft + 2 \n\
>          .endr \n\
> ");
>

Neat macro magic.  Are you thinking that we build this in as a self test 
in the code?

Thanks
-- Cyril.
