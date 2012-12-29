Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2L2NPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 08:15:34 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:54841 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2L2NPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 08:15:30 -0500
MIME-Version: 1.0
In-Reply-To: <1356509964.2710.12.camel@ThinkPad-T5421.cn.ibm.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	<1356028391-14427-3-git-send-email-fweisbec@gmail.com>
	<1356509964.2710.12.camel@ThinkPad-T5421.cn.ibm.com>
Date: Sat, 29 Dec 2012 14:15:29 +0100
Message-ID: <CAFTL4hymw0K42n4KLnGEEuugXE6hiiPBkRJQTJSNA9VfqWPZgQ@mail.gmail.com>
Subject: Re: [PATCH 02/24] cputime: Generic on-demand virtual cputime accounting
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/26 Li Zhong <zhong@linux.vnet.ibm.com>:
> On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 60579d6..a64b3e8 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -340,7 +340,9 @@ config TICK_CPU_ACCOUNTING
>>
>>  config VIRT_CPU_ACCOUNTING
>>       bool "Deterministic task and CPU time accounting"
>> -     depends on HAVE_VIRT_CPU_ACCOUNTING
>> +     depends on HAVE_VIRT_CPU_ACCOUNTING || HAVE_CONTEXT_TRACKING
>> +     select VIRT_CPU_ACCOUNTING_GEN if !HAVE_VIRT_CPU_ACCOUNTING
>> +     default y if PPC64
>
> I saw
> "init/Kconfig:346:warning: defaults for choice values not supported"
> on this line. So maybe we don't need it. And we already have
>         "default VIRT_CPU_ACCOUNTING if PPC64"
>
> Thanks, Zhong

Fixed for the next version, thanks!
