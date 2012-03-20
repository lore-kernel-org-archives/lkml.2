Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab2CTLrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:47:07 -0400
Received: from mail1.windriver.com ([147.11.146.13]:38399 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab2CTLrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:47:05 -0400
Message-ID: <4F686E2A.3090100@windriver.com>
Date: Tue, 20 Mar 2012 06:46:50 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Kgdb-bugreport] [PATCH 4/4] kgdb: x86: Detach gdb if machine
 shuts down or reboots
References: <cover.1331900215.git.jan.kiszka@siemens.com> <f0f7cff3e5a7679de73a3338138f023ed3aca39c.1331900215.git.jan.kiszka@siemens.com> <4F635E06.8070006@windriver.com> <4F673981.8030709@siemens.com> <4F67D6BA.2000500@windriver.com> <4F6867A1.5020906@mvista.com>
In-Reply-To: <4F6867A1.5020906@mvista.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 06:18 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 20-03-2012 5:00, Jason Wessel wrote:
>
>>> An arch-independent hook has its advantages, no question. Maybe we
>>> should just start this way and then evolved on top as needed.
>> Sounds good to me.  I added the reboot notifier patch into the merge queue for kgdb/kdb.
>>> I was wondering why those other archs do not use the notifier. Maybe one
>>> motivation is to avoid that too much code is excluded from the debugger
>>> by detaching too early. Could possibly be addressed by making
>>> detach-on-reboot runtime configurable.
>> There really isn't a whole lot of code between reboot hook invoked from kernel_restart_prepare(),
>> and the place where the reset is invoked.  Specifically it looked like:
>>          usermodehelper_disable();
>>          device_shutdown();
>>          syscore_shutdown();
>>          machine_restart(cmd);
>> Attached is the patch you asked for the conditional behavior with respect to the reboot hook.
>     You forgot to attach it?

Source Forge [kgdb mailling list] is eating attachments.  I had definitely attached it.  See: 

https://lkml.org/lkml/2012/3/19/735

I also included this patch in the potential merge queue as patch 5 of 5, sent to the kgdb mailing list.

http://sourceforge.net/mailarchive/message.php?msg_id=29008292

Jason.


Jason.
