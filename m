Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0IAPvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 11:51:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab0IAPva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 11:51:30 -0400
Date: Wed, 01 Sep 2010 11:51:12 -0400
Subject: Re: [PATCH 1/3] [lockup detector] sync touch_*_watchdog back to old
 semantics
Message-ID: <wjkv24h3mpbpnoxk45o0ts96.1283355915765@email.android.com>
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>
Cc: peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o81Fpgei008911

Top posting because droid won't let me bottom post

This patch was the result of a regression with acpi and preempt.  Akpm asked that I not change the semantics of the old touch_nmi_watchdog.  So I tried to revert to the old behaviour.

Sorry for not properly explaining that.

Cheers,
Don

Ingo Molnar <mingo@elte.hu> wrote:

>
>* Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> On 9/1/10, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> > On 9/1/10, Ingo Molnar <mingo@elte.hu> wrote:
>> >>
>> >> * Don Zickus <dzickus@redhat.com> wrote:
>> >>
>> >>>  void touch_nmi_watchdog(void)
>> >>>  {
>> >>> -	__get_cpu_var(watchdog_nmi_touch) = true;
>> >>> +	if (watchdog_enabled) {
>> >>> +		unsigned cpu;
>> >>> +
>> >>> +		for_each_present_cpu(cpu) {
>> >>> +			if (per_cpu(watchdog_nmi_touch, cpu) != true)
>> >>> +				per_cpu(watchdog_nmi_touch, cpu) = true;
>> >>> +		}
>> >>
>> >> Hm, this is going to be a scalability nightmare with lots of CPUs. Not
>> >> only do we have a nr_cpus loop, but we touch per-cpu areas of _other_
>> >> CPUs - a big scalability nono.
>> >>
>> >> Why do we need to do this? We never needed to touch other CPU's NMI
>> >> lockup accounting data areas - why has this changed? The changelog does
>> >> not explain this.
>> >>
>> >> Thanks,
>> >>
>> >> 	Ingo
>> >>
>> > I believe this came from old nmi watchdog code where it might be
>> > useful when nmi watchdog activated via io-apic. I'm trying to figure
>> > out if we really need it still.
>>
>> Well, we can't drop it or make per-cpu specific, for example we need 
>> it in case of panic with watchdog enabled and panic timeout set, or 
>> boot delay set and etc. Seems same applies to printk_delay. Hmm...
>
>Ok - can you cite the old watchdog code, did it really do a nr_cpus 
>loop?
>
>Thanks,
>
>	Ingo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
