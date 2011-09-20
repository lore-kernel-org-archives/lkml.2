Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1ITOyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:54:15 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:29528 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750740Ab1ITOyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:54:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IFPdwgsVM1lTTs7fRionTRW0l2ro2H8WimKtV_JnMyTK4MW
 Tcc5vK3D2A3XyRyGnVLQVMDJATh0zCkgRe6lgrYcWalAfom4mmWQN18cb3Vn
 Tuh.OWQFX5Xv1Gm7Nuabj6hujIosl_yjZE3.EOEe2tyhPZ2R1GXpyselHAkj
 s7pRCWxEzoWgnpMF9C.S.RW8cRy6pVx2kJmIvyrCdseb3p6KNSU8as_KNV43
 AAX4mAx4JZ7h2IP0ALjt.ilnDfIjICq6sMhJQMLgj.pKln2FR7nNg6Yj5PIy
 YTDC77tnl48y1TRgzaLdy1XBUSUobr2SfPVOYxtrI7jxq9RiYMqXPPx1B5wg
 Nf5TDkJKzEpfLrfiK.WFDtdVadVrEabka3JsdGMqa_w8MwmA-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 09:54:10 -0500 (CDT)
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
In-Reply-To: <1316475208.29966.2.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1109200952460.8056@router.home>
References: <20110919212040.745370781@goodmis.org>  <20110919212641.302263742@goodmis.org>  <alpine.DEB.2.00.1109191653460.19059@router.home> <1316475208.29966.2.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Steven Rostedt wrote:

> Note, just because something is always in a location that preemption is
> disabled, does not mean it should use the __this_cpu*() variants.

Why not? If preemption is disabled then the process cannot be migrated to
another processor. And thus doing the address calculations and operations
on variables step by step is okay.

> Because if things change, it may become a problem later on.

What things may change? Someone calls the function with preemption
enabled?
