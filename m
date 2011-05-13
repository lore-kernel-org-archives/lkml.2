Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab1EMWIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 18:08:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54295 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1EMWIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 18:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PWagmUVFCcguIweC8CulWiUn60i6wJDkho3eHbMQU9KcTWkSVvw9y+MQvafZz5yYS8
         gxJiDqgjDvt0ljmVWUXya6CCFUAyhcYAWGtAbFfxCPgDHGYA/uRBKo0WLp4BgL8Wuq70
         PPtqWMN3cqnKQs96bcI5bp5u+ImKf337eqYZA=
MIME-Version: 1.0
In-Reply-To: <20110428183434.GG30645@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	<20110428183434.GG30645@1wt.eu>
Date: Sat, 14 May 2011 00:08:36 +0200
Message-ID: <BANLkTikKsrfCCod6QiXe5308Xu0uZQH+bA@mail.gmail.com>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
From: Nicolas Carlier <chronidev@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>,
        =?ISO-8859-1?Q?Herv=E9_Commowick?= <hcommowick@exosec.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

On Thu, Apr 28, 2011 at 8:34 PM, Willy Tarreau <w@1wt.eu> wrote:
> Hello Nikola,
>
> On Thu, Apr 28, 2011 at 10:26:25AM +0200, Nikola Ciprich wrote:
>> Hello everybody,
>>
>> I'm trying to solve strange issue, today, my fourth machine running 2.6.32.21 just crashed. What makes the cases similar, apart fromn same kernel version is that all boxes had very similar uptimes: 214, 216, 216, and 224 days. This might just be a coincidence, but I think this might be important.
>
> Interestingly, one of our customers just had two machines who crashed
> yesterday after 212 days and 212+20h respectively. They were running
> debian's 2.6.32-bpo.5-amd64 which is based on 2.6.32.23 AIUI.
>
> The crash looks very similar to the following bug which we have updated :
>
>   https://bugzilla.kernel.org/show_bug.cgi?id=16991
>
> (bugzilla doesn't appear to respond as I'm posting this mail).
>
> The top of your ouput is missing. In our case as in the reports on the bug
> above, there was a divide by zero error. Did you happen to spot this one
> too, or do you just not know ? I observe "divide_error+0x15/0x20" in one
> of your reports, so it's possible that it matches the same pattern at least
> for one trace. Just in case, it would be nice to feed the bugzilla entry
> above.
>
>> Unfortunately I only have backtraces of two crashes (and those are trimmed, sorry), and they do not look as similar as I'd like, but still maybe there is something in common:
>>
>> [<ffffffff81120cc7>] pollwake+0x57/0x60
>> [<ffffffff81046720>] ? default_wake_function+0x0/0x10
>> [<ffffffff8103683a>] __wake_up_common+0x5a/0x90
>> [<ffffffff8103a313>] __wake_up+0x43/0x70
>> [<ffffffffa0321573>] process_masterspan+0x643/0x670 [dahdi]
>> [<ffffffffa0326595>] coretimer_func+0x135/0x1d0 [dahdi]
>> [<ffffffff8105d74d>] run_timer_softirq+0x15d/0x320
>> [<ffffffffa0326460>] ? coretimer_func+0x0/0x1d0 [dahdi]
>> [<ffffffff8105690c>] __do_softirq+0xcc/0x220
>> [<ffffffff8100c40c>] call_softirq+0x1c/0x30
>> [<ffffffff8100e3ba>] do_softirq+0x4a/0x80
>> [<ffffffff810567c7>] irq_exit+0x87/0x90
>> [<ffffffff8100d7b7>] do_IRQ+0x77/0xf0
>> [<ffffffff8100bc53>] ret_from_intr+0x0/Oxa
>> <EUI> [<ffffffffa019e556>] ? acpi_idle_enter_bm+0x273/0x2a1 [processor]
>> [<ffffffffa019e54c>] ? acpi_idle_enter_bm+0x269/0x2a1 [processor]
>> [<ffffffff81280095>] ? cpuidle_idle_call+0xa5/0x150
>> [<ffffffff8100a18f>] ? cpu_idle+0x4f/0x90
>> [<ffffffff81323c95>] ? rest_init+0x75/0x80
>> [<ffffffff81582d7f>] ? start_kernel+0x2ef/0x390
>> [<ffffffff81582271>] ? x86_64_start_reservations+0x81/0xc0
>> [<ffffffff81582386>] ? x86_64_start_kernel+0xd6/0x100
>>
>> this box (actually two of the crashed ones) is using dahdi_dummy module to generate timing for asterisk SW pbx, so maybe it's related to it.
>>
>>
>> [<ffffffff810a5063>] handle_IRQ_event+0x63/0x1c0
>> [<ffffffff810a71ae>] handle_edge_irq+0xce/0x160
>> [<ffffffff8100e1bf>] handle_irq+0x1f/0x30
>> [<ffffffff8100d7ae>] do_IRQ+0x6e/0xf0
>> [<ffffffff8100bc53>] ret_from_intr+0x0/Oxa
>> <EUI> [<ffffffff8133?f?f>] ? _spin_un1ock_irq+0xf/0x40
>> [<ffffffff81337f79>] ? _spin_un1ock_irq+0x9/0x40
>> [<ffffffff81064b9a>] ? exit_signals+0x8a/0x130
>> [<ffffffff8105372e>] ? do_exit+0x7e/0x7d0
>> [<ffffffff8100f8a7>] ? oops_end+0xa7/0xb0
>> [<ffffffff8100faa6>] ? die+0x56/0x90
>> [<ffffffff8100c810>] ? do_trap+0x130/0x150
>> [<ffffffff8100ccca>] ? do_divide_error+0x8a/0xa0
>> [<ffffffff8103d227>] ? find_busiest_group+0x3d7/0xa00
>> [<ffffffff8104400b>] ? cpuacct_charge+0x6b/0x90
>> [<ffffffff8100c045>] ? divide_error+0x15/0x20
>> [<ffffffff8103d227>] ? find_busiest_group+0x3d7/0xa00
>> [<ffffffff8103cfff>] ? find_busiest_group+0x1af/0xa00
>> [<ffffffff81335483>] ? thread_return+0x4ce/0x7bb
>> [<ffffffff8133bec5>] ? do_nanosleep+0x75/0x30
>> [<ffffffff810?1?4e>] ? hrtimer_nanosleep+0x9e/0x120
>> [<ffffffff810?08f0>] ? hrtimer_wakeup+0x0/0x30
>> [<ffffffff810?183f>] ? sys_nanosleep+0x6f/0x80
>>
>> another two don't use it. only similarity I see here is that it seems to be IRQ handling related, but both issues don't have anything in common.
>> Does anybody have an idea on where should I look? Of course I should update all those boxes to (at least) latest 2.6.32.x, and I'll do it for sure, but still I'd first like to know where the problem was, and if it has been fixed, or how to fix it...
>> I'd be gratefull for any help...
>
> There were quite a bunch of scheduler updates recently. We may be lucky and
> hope for the bug to have vanished with the changes, but we may as well see
> the same crash in 7 months :-/
>
> My coworker Hervé (CC'd) who worked on the issue suggests that we might have
> something which goes wrong past a certain uptime (eg: 212 days), which needs
> a special event to be triggered (I/O, process exiting, etc...). I think this
> makes quite some sense.
>
> Could you check your CONFIG_HZ so that we could convert those uptimes to
> jiffies ? Maybe this will ring a bell in someone's head :-/
>

We had encounter the same issue on many nodes of our cluster which ran
on a 2.6.32.8 Debian Kernel. All the servers which had crashed, had
almost the same uptime, more than 200 days. But those which didn't
crashed,  had the same uptime.

Each time, we had the "divide by zero" in "find_busiest_group"

One explanation can be the difference in term of number of  tasks since boot.

As the servers fallen one by one, and as we were not able to reproduce
the problem quickly, we had  use the patch provides by  Andrew
Dickinson.

Regards,

--
Nicolas Carlier
