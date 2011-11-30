Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab1K3L4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:56:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:57702 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab1K3L4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:56:32 -0500
Message-ID: <1322654168.2921.257.camel@twins>
Subject: Re: Perhaps a side effect regarding NMI returns
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
Date: Wed, 30 Nov 2011 12:56:08 +0100
In-Reply-To: <1322607086.17003.94.camel@frodo>
References: <1322539673.17003.45.camel@frodo>
	 <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
	 <m2r50qlmgk.fsf@firstfloor.org>
	 <CA+55aFxyBYFbx=AGgJ35Dx+U8KVPktesHetYnQrYpt1QGKTrbQ@mail.gmail.com>
	 <20111129203111.GQ24062@one.firstfloor.org>
	 <CA+55aFxUFkHGXk_eEN1GYsZWe5_G9uoCP6DkL6bw9+wWP2_fcw@mail.gmail.com>
	 <1322600301.17003.84.camel@frodo>  <20111129221419.GE6610@redhat.com>
	 <1322607086.17003.94.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 17:51 -0500, Steven Rostedt wrote:
> static void run_sync(void)
> {
>         int enable_irqs = irqs_disabled();
> 
>         /* We may be called with interrupts disbled. */
>         if (enable_irqs)
>                 local_irq_enable();
>         on_each_cpu(do_sync_core, NULL, 1);
>         if (enable_irqs)
>                 local_irq_disable();
> }
> 
> Note, it's fine to enable interrupts here, it's only used by ftrace. 

Still ugly as hell though, why not push that pain to the caller?
