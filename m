Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0IBOer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab0IBOeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:34:46 -0400
Message-ID: <4C7FB603.60609@redhat.com>
Date: Thu, 02 Sep 2010 17:34:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: kernelshark plugins and ftrace array fields
References: <4C7F9639.7000804@redhat.com> <1283437521.2356.136.camel@gandalf.stny.rr.com>
In-Reply-To: <1283437521.2356.136.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/02/2010 05:25 PM, Steven Rostedt wrote:
> On Thu, 2010-09-02 at 15:19 +0300, Avi Kivity wrote:
>> I'd like to add enhance kvm_emulate_insn display in kernelshark to
>> show the disassembly of the instruction being emulated.  However,
>> pevent_get_field_val() doesn't support arrays (the instruction is
>> provided in a 15-byte array).
>>
>> Can you add support for arrays in the kernelshark API?  With that, it
>> looks like adding disassembly output to the kvm plugin should be quite
>> simple.
>>
> Sure, I could add a pevent_get_field_array() or something. Could you
> tell me the event and give me an example of what you want to do.

plugin_kvm.c:

kvm_emulate_insn_handler()
{
    fetch insn array and len field
    feed into disassembler
    trace_seq_printf() the disassembled instruction
}

-- 
error compiling committee.c: too many arguments to function

