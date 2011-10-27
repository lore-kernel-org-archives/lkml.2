Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1J0Lmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 07:42:55 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:60591 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1J0Lmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 07:42:54 -0400
Message-ID: <4EA943B0.4050107@numascale.com>
Date: Thu, 27 Oct 2011 13:42:40 +0200
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/3] Add multi-node boot support
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com> <1319609230-18897-2-git-send-email-daniel@numascale-asia.com> <20111027073029.GD15923@elte.hu> <4EA93699.9000101@numascale.com> <20111027113819.GA19682@elte.hu>
In-Reply-To: <20111027113819.GA19682@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 13:38, Ingo Molnar wrote:
>
> * Steffen Persvold<sp@numascale.com>  wrote:
>
>>> If it's absolutely needed then add a proper quirk handler instead
>>> of polluting the generic code.
>>
>> We wanted to reuse as much of the generic AMD code as possible, but
>> it's tricky because most of that code is based around a single HT
>> fabric design, whereas a NumaChip based systems consists of several
>> HT fabrics connected together thus you will have identical
>> NorthBridge IDs (0-7) etc. shared between all systems.
>>
>> How would you suggest we add a quirk handler for it ?
>
> So what we want on NumaChip systems is for the node ID in the BIOS
> SRAT table to override the node ID that is read from the hardware,
> right?

Correct. Our bootloader modifies the SRAT table with the new IDs, and 
initializes all processors with new real APIC IDs but we can't do 
anything with the initial APIC ID.

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
