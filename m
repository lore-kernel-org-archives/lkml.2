Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab0DMRQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 13:16:13 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:48384 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab0DMRQL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 13:16:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACtAxEtGGNwY/2dsb2JhbACDFJg3cqwukUuBLIJzbgQ
Date: Tue, 13 Apr 2010 13:16:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20100413171604.GA22551@Krystal>
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <4B4D02B8.5020801@zytor.com> <20100113020610.GB29314@Krystal> <4B4D525A.5020101@zytor.com> <20100113143050.GB30875@Krystal> <4B4F665F.1090900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4B4F665F.1090900@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:15:49 up 6 days,  3:09,  1 user,  load average: 0.19, 0.17,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Mathieu Desnoyers wrote:
> >> It is *not* necessary to wait for the breakpoint handlers to return, as
> >> long as they will get to IRET eventually, since IRET is a jump and a
> >> serializing instruction.
> > 
> > Ah, I see. So the added smp_mb() would not be needed then, as long as we
> > know that the other CPUs either are currently running the IPI handler or
> > have executed it. IOW: they will execute IRET very soon or they just
> > executed it since the int3 have been written. I am a bit concerned about
> > NMIs coming in this race window, but as they need to have started after
> > we have put the breakpoint, that should be OK. (note: entry_*.S
> > modifications are needed to support nesting breakpoint handlers in NMIs)
> 
> Hmm, if we support this to modify NMI code, it seems that we need to
> support not only nesting breakpoint handling but also nesting NMIs,
> because nesting NMI is unblocked when next IRET (of breakpoint) is
> issued.
> 
> From Intel's Software Developer’s Manual Vol.3A 5.7.1 Handling Multiple NMIs
> said below.
> ---
> While an NMI interrupt handler is executing, the processor disables additional calls to
> the NMI handler until the next IRET instruction is executed. This blocking of subse-
> quent NMIs prevents stacking up calls to the NMI handler. [...]
> ---
> 
> I assume that your below patch tried to solve this issue, right?
> http://lkml.indiana.edu/hypermail/linux/kernel/0804.1/0965.html
> 

Yep. (sorry about late reply).

Mathieu

> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
