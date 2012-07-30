Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab2G3PPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:15:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:35652 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2G3PPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:15:42 -0400
Message-ID: <5016A517.8000702@linutronix.de>
Date: Mon, 30 Jul 2012 17:15:35 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH] uprobes: don't enable/disable signle step if the user
 did it
References: <1343316043-13475-1-git-send-email-bigeasy@linutronix.de> <20120730110658.GC11147@in.ibm.com> <20120730141638.GA5306@redhat.com>
In-Reply-To: <20120730141638.GA5306@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 04:16 PM, Oleg Nesterov wrote:

> I'd suggest you to make 2 patches:
>
> 	- 1/2 creates arch_uprobe_*_step(...) __weak helpers in
> 	      kernel/events/uprobes.c which simply call
> 	      user_*_single_step() and updates the callers
>
> 	      Not strictly necessary, but imho makes sense...
>
> 	- 2/2 adds the x86 implementation in arch/x86/kernel/uprobes.c
> 	      which still uses user_*_single_step() but checks
> 	      TIF_SINGLESTEP. As your patch does, but you should use
> 	      utask, not uprobe.
>
> IOW, I simply suggest to make your patch x86-specific. Then we
> will try to do more fixes/improvements.
>
>
> Sebastian, Ananth, what do you think?

Yup, let me try…

>
> Oleg.
>

Sebastian
