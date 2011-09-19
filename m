Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1ISVvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:51:14 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:27520 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756409Ab1ISVvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:51:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wrUrTu8VM1ksht7GBVbb4K7nG_WYzFrIBvqd75.qzJFOAP0
 cmNCKxI5qxMMykDD0UqnoCIqdvHNG8kNbW_HcmYfhxPjddLBcoOHmE1K0.Dk
 UQEkgRYg97n51WwutstS_iqHMjYNZiKrpBtukLgRRg7GcL9S8D14CqtXn4q7
 N7dCRli_wSsifEFPaJFcfiRQuf7KD2uOJl7AvwxqQDFPaoqWvj56Uc_8Uvr8
 E.9ufKdvA0R7ErJK1u1.Zdxe.mvuyWGYJvEr8QjPuVOAUIbqw585KgwoGCQj
 v645O_gTd9rfA5aaLdPefZlGy8a2i8N62eO_DIkzs8GhV8xWdfmgbm_qALHx
 YEy2ZeN7zO8IKK_epGI_LnOWlnYq7uMPSOVOCuiho8arEvmw.RLAKWzqqYVv
 qSgvM8aPRAIhGEVch5LYqQHo-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Sep 2011 16:51:10 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [RFC][PATCH 1/5] x86: Remove const_udelay() caring about which
 cpu var it uses
In-Reply-To: <20110919212640.343186687@goodmis.org>
Message-ID: <alpine.DEB.2.00.1109191650010.19059@router.home>
References: <20110919212040.745370781@goodmis.org> <20110919212640.343186687@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Steven Rostedt wrote:

> The __const_udelay() code originally used raw_smp_processor_id()
> in its calculations for a delaying. Probably because if it were
> to migrate, it would take much longer to do so than the requested
> delay.
>
> Switch from this_cpu_read() to __this_cpu_read() to document that
> the read is racy and we do not care.

Is preemption disabled by all callers to __const_udelay?
