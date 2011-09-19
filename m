Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1ISVy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:54:59 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:44232 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755133Ab1ISVy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:54:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: JxFOykMVM1lbLinmh9QuK76f3BAsnjBfOG_clMhj65COczV
 Zh2uw.xKsBhTNtvrWJHQf30UkQxa7oQxk6f6TTSLco1ThSpZOdZCTfRs8iqs
 Uxah45OzC1f_LeW8FFyayABDzzzUUpBbHsBRrmkgA.kxQhnL8Q58GrI97WcG
 _H1yQowIsPY4vYIbsuXy3NgrSSVhvdXOfeKcMBnG6f6jIuQk66jOndm6wYrp
 .TBPE9K945g3h2KFqJRnctTncHDSbyp5HDjiMmD7YRWvKERR_x1tnXq8aFFW
 3G8zT_PlwhqAySmvIYJH.i1lDaemShC5eUFXqzibL21naQnBjGBLLQO90dB1
 gwa6eCWoWbsijUup8CezPffjNuKgIl9nAQ_J61xvhCZvpHNA-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Sep 2011 16:54:55 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [RFC][PATCH 4/5] printk: Have wake_up_klogd() use
 __this_cpu_write()
In-Reply-To: <20110919212641.302263742@goodmis.org>
Message-ID: <alpine.DEB.2.00.1109191653460.19059@router.home>
References: <20110919212040.745370781@goodmis.org> <20110919212641.302263742@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Steven Rostedt wrote:

> From: Steven Rostedt <srostedt@redhat.com>
>
> The wake up code that triggers klogd does not really matter which
> CPU it enables the wake up on. Every CPU will be doing a printk_tick()
> and check the current CPU. As long as one of the CPUs triggers the
> wakeup we are fine. Use __this_cpu_write() instead of this_cpu_write()
> to show that we do not care.

printk_needs_cpu() is always called from context where we have disabled
interrupts therefore this is safe to do.

Reviewed-by: Christoph Lameter <cl@gentwo.org>

