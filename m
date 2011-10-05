Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935453Ab1JEWDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 18:03:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935355Ab1JEWDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 18:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <4E8980A6.8000905@linux.vnet.ibm.com>
References: <CAG1a4rtrh7=+gr=kUGO6y4wt926F8rBusOcFgvu4CmvrmR5PCw@mail.gmail.com>
 <1317358146.9597.11.camel@PavelComp> <4E8980A6.8000905@linux.vnet.ibm.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Wed, 5 Oct 2011 18:03:01 -0400
Message-ID: <CAG1a4ruZM6F8yWRRAuq9aKv+F1woQz7TS3xUCM+Tx8gzq66G_Q@mail.gmail.com>
Subject: Re: [RFC PATCH] Allow for stack traces to be printed on serial console
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 5:30 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 09/30/2011 10:19 AM, Pavel Ivanov wrote:
>> When I tried to chase some mysterious lockup of my PC the only means to
>> see some error reports for me was serial console. But it looks like only
>> printk with KERN_ERR is sent to serial console. So when hung task
>> detector tried to show me stack traces for hung tasks I didn't see them
>> on serial console and I didn't see them after reboot as they couldn't be
>> saved to dmesg. Thus the following patch allowed me to actually see
>> those stack traces.
>
> Which kernel messages gets displayed on your serial console is controlled by
> your system configuration which can be altered by modifying /etc/rsyslog.conf
> or /etc/sysconfig/syslog.conf
> There you can specify that you want to print every kernel message by specifying
> kern.* for example.

I've tried to add "kern.* /dev/ttyS0" and "*.* /dev/ttyS0" to
/etc/rsyslog.conf but it didn't help at all.

> There are also some kernel command line options you can use to specify which
> level of kernel messages you want to get displayed.

I've tried to add loglevel=7 as bootup parameter but it didn't help.
Then I've tried to
"echo $'7\t7\t1\t7' >/proc/sys/kernel/printk" and it helped a little
(message with level KERN_INFO was printed from sched_show_task() to
serial console). But still I wasn't able to see stack traces. Do I
miss something?

> Since you clearly have a system configuration problem here, you don't need to alter the
> kernel source to print with KERN_ERR everywhere. Doing that would also defeat the very
> purpose of having that nice distinction between informational messages, error messages
> and so on, isn't it?

Sure. But what configuration parameter should I tune?

I proposed this patch because I didn't believe that there can be cases
when kernel wants to print stack trace and somebody looking at serial
console doesn't want to see it. But of course I can live with some
configuration parameter as long as I find it.


>> I believe kernel prints stack traces only in some serious cases and
>> expects that they would be actually seen, so KERN_ERR looks justified
>> for me in all changed places. I understand that patch is incomplete and
>> would need some other places to be changed for consistency (at least
>> other arch code). But first I want to hear comments on whether this
>> approach is good enough to be included in mainline or it should be left
>> for me as a hack.
