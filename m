Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab2KTKi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:38:59 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58154 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2KTKi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:38:56 -0500
X-AuditID: b753bd60-97c52ba000002f78-10-50ab5dbddfe3
X-AuditID: b753bd60-97c52ba000002f78-10-50ab5dbddfe3
Message-ID: <50AB5DBD.5050901@hitachi.com>
Date: Tue, 20 Nov 2012 19:38:53 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
References: <20121114013611.5338.15086.stgit@yunodevel>   <1352858437.18025.47.camel@gandalf.local.home>   <CAJL_ekvb89saY9F0F3ip-8xipuuRyJ1_M8hOyThu_0Q2=5sXgA@mail.gmail.com>  <1352860305.18025.48.camel@gandalf.local.home>  <50A355A2.5040101@hitachi.com> <1353078354.7586.14.camel@gandalf.local.home>
In-Reply-To: <1353078354.7586.14.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Sorry for the late reply.

(2012/11/17 0:05), Steven Rostedt wrote:
> On Wed, 2012-11-14 at 17:26 +0900, Yoshihiro YUNOMAE wrote:
>> Thank you for commenting on my patch set.
>>
>> (2012/11/14 11:31), Steven Rostedt wrote:
>>> On Tue, 2012-11-13 at 18:03 -0800, David Sharp wrote:
>>>> On Tue, Nov 13, 2012 at 6:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>>>> On Wed, 2012-11-14 at 10:36 +0900, Yoshihiro YUNOMAE wrote:
>>>>>
>>>>>> To merge the data like previous pattern, we apply this patch set. Then, we can
>>>>>> get TSC offset of the guest as follows:
>>>>>>
>>>>>> $ dmesg | grep kvm
>>>>>> [   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
>>>>>>                        ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
>>>>>>                        PID                         TSC offset                 |
>>>>>>                                                              HOST TSC value --+
>>>>>>
>>>>>
>>>>> Using printk to export something like this is IMO a nasty hack.
>>>>>
>>>>> Can't we create a /sys or /proc file to export the same thing?
>>>>
>>>> Since the value changes over the course of the trace, and seems to be
>>>> part of the context of the trace, I think I'd include it as a
>>>> tracepoint.
>>>>
>>>
>>> I'm fine with that too.
>>
>> Using some tracepoint is a nice idea, but there is one problem. Here,
>> our discussion point is "the event which TSC offset is changed does not
>> frequently occur, but the buffer must keep the event data."
>
> If you can hold off a bit, for the 3.9 window, I plan on pushing
> multiple buffers for ftrace. That is, you can create a separate buffer
> just for the TSC offset events:
>
> cd /sys/kernel/debug
> echo tsc > instances/new
> echo 1 > instances/tsc/events/tsc/offset/enable
>
> Then the buffer will be used only for that event.

That's good. The tracepoint will output as follows:

qemu-kvm-12345  [000] ....123456789: kvm_write_tsc_offset:
now_tsc=123456789 previous_offset=0 next_offset=123456780

Thanks,
-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


