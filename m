Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab0LHBtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:49:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62025 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab0LHBtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:49:20 -0500
Message-ID: <4CFEE3A2.2050908@kernel.org>
Date: Tue, 07 Dec 2010 17:47:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Feng Tang <feng.tang@intel.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/platform] x86: Unify current 3 similar ways of saving
 IRQ info
References: <1291349518-3502-1-git-send-email-feng.tang@intel.com> <tip-a6427a341985e0379060c86b50fcdb59883e4102@git.kernel.org> <4CFD226C.60308@kernel.org> <20101207133204.4d913c5a@feng-i7> <alpine.LFD.2.00.1012071654080.2653@localhost6.localdomain6> <4CFE8045.2030101@kernel.org> <alpine.LFD.2.00.1012072327000.2653@localhost6.localdomain6> <4CFEE2D3.6050107@kernel.org>
In-Reply-To: <4CFEE2D3.6050107@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 05:43 PM, Yinghai Lu wrote:
> On 12/07/2010 02:32 PM, Thomas Gleixner wrote:
>> On Tue, 7 Dec 2010, Yinghai Lu wrote:
>>> On 12/07/2010 07:56 AM, Thomas Gleixner wrote:
>>>>
>>>>   Same here. No caller is interested in the detailed return value.
>>>>
>>>
>>
>>> ok, after look at code and git log, i knew the reasons for those
>>> strange duplicated functions.
>>>
>>> Alexy changed
>>>
>>>  /* MP IRQ source entries */
>>> -struct mpc_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
>>> +struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
>>>
>>> to make it decouple that with mpstable definition. so mptable will
>>> have mpc_intsrc, and acpi etc will use mp_config_intsrc
>>>
>>> and he planed to add more member to mp_config_intsrc .... never happened.
>>>
>>> then I added those functions with different parameters.
>>>
>>> one year later JSR changed all back to mpc_instr...
>>>
>>> so now have some duplicated functions....
>>
>>> So yes, we should use simple versions in
>>> arch/x86/kernel/acpi/boot.c. ( assume functions mrst.c are copied
>>> from there)
>>>
>>> and should kill print_mp_irq_info or print_MP_intsrc_info...
>>
>> Nice archaelogical detective work ! :)
>>
>> So now I have Fengs patch plus Yinghais series which seem to go nicely
>> together, but I have the feeling that there is some stuff unresolved.
>>
>> Yinghai, Feng: could you please work out the missing bits an pieces
>> (if any) and provide me a delta patch on top of the existing patches?
>>
> 
> Maybe Feng could send you updated version with simpler function?
> 

also I prefer to keep save_mp_irq() instead of changing it to mp_save_irq().

Thanks

	Yinghai
