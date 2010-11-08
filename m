Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0KHV5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:57:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58339 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab0KHV5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:57:31 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings v2
References: <1289251229-19589-1-git-send-email-andi@firstfloor.org>
	<alpine.LFD.2.00.1011082238420.2900@localhost6.localdomain6>
Date: Mon, 08 Nov 2010 22:57:30 +0100
In-Reply-To: <alpine.LFD.2.00.1011082238420.2900@localhost6.localdomain6>
	(Thomas Gleixner's message of "Mon, 8 Nov 2010 22:39:49 +0100 (CET)")
Message-ID: <87oc9zqy0l.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Mon, 8 Nov 2010, Andi Kleen wrote:
>>  static inline u32 native_apic_msr_read(u32 reg)
>>  {
>> -	u32 low, high;
>> +	u32 low;
>>  
>>  	if (reg == APIC_DFR)
>>  		return -1;
>>  
>> -	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
>> -	return low;
>> +	rdmsrl(APIC_BASE_MSR + (reg >> 4), low);
>> +	return (u32)low;
>
> What's the point of casting u32 to u32 ?

One of the earlier reviewers thought adding an explicit cast would make
the truncation in the code clearer.  I didn't full agree either, but 
still did the change.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
