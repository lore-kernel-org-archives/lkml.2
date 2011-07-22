Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1GVO6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:58:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:45731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab1GVO6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:58:02 -0400
Subject: Re: On migrate_disable() and latencies
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>
In-Reply-To: <1311331798.27400.28.camel@twins>
References: <1311329992.27400.23.camel@twins>
	 <1311331798.27400.28.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Jul 2011 16:57:43 +0200
Message-ID: <1311346663.9642.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 12:49 +0200, Peter Zijlstra wrote:
> > The scenario is on where you stack N migrate-disable tasks on a run
> > queue (necessarily of increasing priority). Doing this requires all cpus
> > in the system to be as busy, for otherwise the task would simply be
> > moved to another cpu.
> 
> This implies it requires at least nr-cpus^2 tasks to pull this off. 

OK, scrap that, 2*nr-cpus is enough.
