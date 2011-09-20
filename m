Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103Ab1ITO4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:56:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55325 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1ITO4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:56:19 -0400
Subject: Re: [RFC][PATCH 4/5] printk: Have wake_up_klogd() use
 __this_cpu_write()
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>
Date: Tue, 20 Sep 2011 16:55:53 +0200
In-Reply-To: <alpine.DEB.2.00.1109200952460.8056@router.home>
References: <20110919212040.745370781@goodmis.org>
	  <20110919212641.302263742@goodmis.org>
	  <alpine.DEB.2.00.1109191653460.19059@router.home>
	 <1316475208.29966.2.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109200952460.8056@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316530554.13664.35.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 09:54 -0500, Christoph Lameter wrote:
> On Mon, 19 Sep 2011, Steven Rostedt wrote:
> 
> > Note, just because something is always in a location that preemption is
> > disabled, does not mean it should use the __this_cpu*() variants.
> 
> Why not? If preemption is disabled then the process cannot be migrated to
> another processor. And thus doing the address calculations and operations
> on variables step by step is okay.
> 
> > Because if things change, it may become a problem later on.
> 
> What things may change? Someone calls the function with preemption
> enabled? 

Yes, also, for !x86 you get a redundant preempt_disable/enable pair.


