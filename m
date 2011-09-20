Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1ITQKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:10:54 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:28036 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751790Ab1ITQKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:10:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RyWiRJgVM1nt.in5wqxJRsBLnmY0rlDUpZi3fH7_5MPof6x
 5cRqrdM4dDNA5co5zDmb.GoQSmW_0_7NVT8MEYdbuLelFaKPxHZrvynDIjbm
 qkoH3hUGkIV78AhYy08fDBEkUUZCelFhjG3IErdTiadC_anAM32Pou3a7Zz6
 bWvzql.2NX6GAw0qbJYG6N0PRjqbbLywD4YMWnHP6SUwnVPaRVGOgO9gE.qs
 71hbPEvvgF05Db.EiC9TXCDKJZB69eYRE4IKRX19l0SFhJV6psA4skmNcBBC
 oaxSbVcEH0vvv8TxiCmupT1w5tzkZ54aXiJpphr8DH2fMQKkSUrQQ0ZZDU_C
 6xo_7au1SXYFhwk6Kzo3BkNI6t2x_93j84N2Vj45U8mGElHI-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 11:10:50 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <1316534441.29966.79.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1109201109470.8056@router.home>
References: <20110919212040.745370781@goodmis.org>  <alpine.DEB.2.00.1109191644190.19059@router.home>  <1316487977.29966.32.camel@gandalf.stny.rr.com>  <20110920154610.GB28952@Krystal> <1316534441.29966.79.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Steven Rostedt wrote:

> I really mean all other users of this_cpu_*(), including the cmpxchg and
> friends, still need to have preemption disabled.

This is argument against the basic design of this_cpu_ops. They were
designed to avoid having to disable preemption for single operations on
per cpu data. I think this shows a basic misunderstanding of what you are
dealing with.


