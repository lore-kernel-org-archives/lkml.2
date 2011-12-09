Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1LIRtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:49:21 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50292 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1LIRtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:49:20 -0500
Date: Fri, 9 Dec 2011 18:49:11 +0100
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
Message-ID: <20111209174911.GD14900@aftab>
References: <20111208193003.112037550@goodmis.org>
 <20111208193136.366941904@goodmis.org>
 <1323373012.30977.123.camel@frodo>
 <1323398616.30977.167.camel@frodo>
 <1323448478.1937.26.camel@frodo>
 <1323451171.1937.33.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323451171.1937.33.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Steve,

On Fri, Dec 09, 2011 at 12:19:31PM -0500, Steven Rostedt wrote:
> Could you shed some light on this. Can an NMI interrupt an MCE in
> progress?

Easy, http://support.amd.com/us/Processor_TechDocs/APM_V2_24593.pdf,
section 8.5.

On amd64 #MC is along with processor reset the highest prio. Judging
from the text, an NMI occurring during an #MC is held until we return
from the #MC handler:

"When simultaneous interrupts occur, the processor transfers control
to the highest-priority interrupt handler. Lower-priority interrupts
from external sources are held pending by the processor, and they are
handled after the higher-priority interrupt is handled. Lower-priority
interrupts that result from internal sources are discarded. Those
interrupts reoccur when the high-priority interrupt handler completes
and transfers control back to the interrupted instruction."

HTH.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
