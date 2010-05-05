Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934876Ab0EEOdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:33:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:33283 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab0EEOdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:33:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,333,1270450800"; 
   d="scan'208";a="619101699"
Message-ID: <4BE181BD.8010804@linux.intel.com>
Date: Wed, 05 May 2010 07:33:33 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: =?UTF-8?B?Um9ubnkgVHNjaMO8dGVy?= <Ronny.Tschueter@tu-dresden.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Tracing of power:power_start events doesn't work
References: <4BDECD66.2010906@tu-dresden.de>	 <1273019517.22438.10.camel@gandalf.stny.rr.com>	 <4BE17C90.2020205@tu-dresden.de> <1273069881.22438.17.camel@gandalf.stny.rr.com>
In-Reply-To: <1273069881.22438.17.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/2010 7:31, Steven Rostedt wrote:
> On Wed, 2010-05-05 at 16:11 +0200, Ronny Tsch�ter wrote:
>
>>    /*
>>     * Include the apic definitions for x86 to have the APIC timer related
>> defines
>> @@ -796,6 +797,18 @@ static int acpi_idle_bm_check(void)
>>     */
>>    static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
>>    {
>> +    switch (cx->type) {
>> +    case ACPI_STATE_C1:
>> +        trace_power_start(POWER_CSTATE, 1);
>> +        break;
>> +    case ACPI_STATE_C2:
>> +        trace_power_start(POWER_CSTATE, 2);
>> +        break;
>> +    case ACPI_STATE_C3:
>> +        trace_power_start(POWER_CSTATE, 3);
>> +        break;
>> +    }
>> +
>
> Depending on gcc, the above can bloat the code since each call to
> trace_power_start() is a macro expanded. Try to call it just once.
> Perhaps one of the following:

the code is also incorrect fundamentally.
You need to pass in the mwait value or equivalent; the ACPI STATE type is
pretty much useless random garbage and should completely be ignored.
