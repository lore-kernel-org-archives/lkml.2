Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab1ITO5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:57:37 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:27341 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750957Ab1ITO5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:57:36 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WNyzcNIVM1nkW9setNAA81wBtmufkqVRXuNLHrxxdkH37BJ
 a3CJNpdCujTRpIWWDg68C8S8SK71KVD5il8aqnuxCD8tlPHUBg84cAXR7kPe
 14HsaG7_7OkCbs6.VgrM8dv_xoZC.OrsjlJsvkv2E6vir9wvSClHF9_FeR_E
 wU6whi8eNEyR_G_2qVLVxT3btKJLRwAiIc3HapRW13x3dmLkS675bOLLY14G
 X8fJYZbqBWlJbxn0nY5Wx.zXt3i13G1k9p.lePqvsPGTxtIB7j_IKLh5FsDp
 1BaaBokfknWaQFoRngG28Q4UB_Aioo9fB8Ug9HFdbKvfcf6tKQ1nZtGjiZK_
 2KspIOTbU91hGiZzC7bZagjR8KDNXSfFADTTx1qWOQPI.PLHsQ8Fpi21vnrA
 NlZUmwiWPULPdCgFbtw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 09:57:32 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Valdis.Kletnieks@vt.edu
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <27409.1316522696@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.2.00.1109200955190.8056@router.home>
References: <20110919212040.745370781@goodmis.org> <alpine.DEB.2.00.1109191644190.19059@router.home>            <1316487977.29966.32.camel@gandalf.stny.rr.com> <27409.1316522696@turing-police.cc.vt.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Valdis.Kletnieks@vt.edu wrote:

> On Mon, 19 Sep 2011 23:06:17 EDT, Steven Rostedt said:
>
> > It is really confusing to know which version to use. I'm confused by the
> > this_cpu_*() compared with __this_cpu_*(). I'm guessing that most places
> > should use __this_cpu*(). But really this_cpu() should be the default,
> > and the places that can have it outside of preemption should have
> > another name. Maybe use the raw_this_cpu() or safe_this_cpu(), as there
> > is an irqsafe_this_cpu(). Maybe make a preemptsafe_cpu_*(). There should
> > only be a very few locations that are OK to have preemption enabled when
> > calling the this_cpu() code. Lets have those have the funny names and
> > not be the default "this_cpu_*()".

this_cpu_xx functions are made for those locations that have
preemption enabled. If you can use those function (classic case is a
per cpu counter increment in the network subsystem) then you can avoid
preempt disable/enable or get_cpu/put_cpu.

