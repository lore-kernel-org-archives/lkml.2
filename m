Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723Ab2CTLUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:20:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41080 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2CTLUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:20:23 -0400
Message-ID: <4F6867A1.5020906@mvista.com>
Date: Tue, 20 Mar 2012 15:18:57 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Kgdb-bugreport] [PATCH 4/4] kgdb: x86: Detach gdb if machine
 shuts down or reboots
References: <cover.1331900215.git.jan.kiszka@siemens.com> <f0f7cff3e5a7679de73a3338138f023ed3aca39c.1331900215.git.jan.kiszka@siemens.com> <4F635E06.8070006@windriver.com> <4F673981.8030709@siemens.com> <4F67D6BA.2000500@windriver.com>
In-Reply-To: <4F67D6BA.2000500@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-03-2012 5:00, Jason Wessel wrote:

>> An arch-independent hook has its advantages, no question. Maybe we
>> should just start this way and then evolved on top as needed.

> Sounds good to me.  I added the reboot notifier patch into the merge queue for kgdb/kdb.

>> I was wondering why those other archs do not use the notifier. Maybe one
>> motivation is to avoid that too much code is excluded from the debugger
>> by detaching too early. Could possibly be addressed by making
>> detach-on-reboot runtime configurable.

> There really isn't a whole lot of code between reboot hook invoked from kernel_restart_prepare(),
> and the place where the reset is invoked.  Specifically it looked like:

>          usermodehelper_disable();
>          device_shutdown();
>          syscore_shutdown();
>          machine_restart(cmd);

> Attached is the patch you asked for the conditional behavior with respect to the reboot hook.

    You forgot to attach it?

> This also implements the ability to stop on a reboot that is not a panic().

WBR, Sergei
