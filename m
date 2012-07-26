Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab2GZTfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 15:35:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:36329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2GZTaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 15:30:16 -0400
Message-ID: <1343330992.26034.92.camel@twins>
Subject: Re: [PATCH 1/1] kthread: disable preemption during complete()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Peter Boonstoppel <pboonstoppel@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Andy Walls <awalls@md.metrocast.net>,
        Diwakar Tundlam <dtundlam@nvidia.com>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 26 Jul 2012 21:29:52 +0200
In-Reply-To: <20120726155409.GB20964@redhat.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com>
	 <20120725000901.GA5304@google.com>
	 <5FBF8E85CA34454794F0F7ECBA79798F379D36485E@HQMAIL04.nvidia.com>
	 <20120725224044.GC32378@google.com> <1343289850.26034.79.camel@twins>
	 <alpine.LFD.2.02.1207261242240.32033@ionos>
	 <20120726155409.GB20964@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 17:54 +0200, Oleg Nesterov wrote:
> Yes, but this "avoid the preemption after wakeup" can actually help
> kthread_bind()->wait_task_inactive() ?

Yeah.

> This reminds me, Peter had a patch which teaches wait_task_inactive()
> to use sched_in/sched_out notifiers to avoid the polling... 

I did, but from what I could remember you shot holes in it and I didn't
find a way to plug them and not make it a bigger mess than it is now :/
