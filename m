Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2HBNUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:20:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:56388 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab2HBNUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:20:30 -0400
Message-ID: <501A7E94.4030309@linutronix.de>
Date: Thu, 02 Aug 2012 15:20:20 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@hack.frob.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        a.p.zijlstra@chello.nl, mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Re: Q: user_enable_single_step() && update_debugctlmsr()
References: <20120801134652.GA4707@redhat.com> <50193528.3070503@linutronix.de> <20120801140121.GA5333@redhat.com> <50193B5C.90404@linutronix.de> <20120801143132.GA7550@redhat.com> <5019427B.1070002@linutronix.de> <20120801150119.GA8845@redhat.com> <50194750.2050601@linutronix.de> <20120801151442.GA9697@redhat.com> <50197994.4090800@linutronix.de> <20120802130509.GA1465@redhat.com>
In-Reply-To: <20120802130509.GA1465@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 03:05 PM, Oleg Nesterov wrote:
> I have no idea what DEBUGCTLMSR_BTF means without X86_EFLAGS_TF
> though. And if gdb itself is TIF_SINGLESTEP'ed, it won't return
> to userspace without report/schedule.

In the Manuel it is only described what happens together with the TF
bit. So one might think nothing. Userland can not read the bit back
however leaking it does not look right.

> But, yes sure! this doesn't look right and this is the source of
> other problems, and this is why I started this thread.
>
>> If the tracee task runs
>
> In the scenario I tried to describe above, the tracee does _not_ run.
>
> gdb switches to _another_ X86_EFLAGS_TF task before the tracee is resumed.
>
>> From the link above,
>
> 	We have the GDB process and the (stopped) tracee T. And we have
> 	another task X
>          ^^^^^^^^^^^^^^

Yes that is correct. Let me try to figure out how to plumb that leak
and fix this before playing with it further.

>
> Oleg.

Sebastian
