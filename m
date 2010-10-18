Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0JRMsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:48:32 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53703 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753509Ab0JRMsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:48:31 -0400
Date: Mon, 18 Oct 2010 08:48:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] jump label: x86 support
Message-ID: <20101018124828.GB25148@Krystal>
References: <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com> <tip-d9f5ab7b1c0a520867af389bab5d5fcdbd0e407e@git.kernel.org> <1287400675.29097.1550.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287400675.29097.1550.camel@twins>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:41:05 up 25 days, 16:43,  1 user,  load average: 0.11, 0.15,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2010-09-24 at 09:01 +0000, tip-bot for Jason Baron wrote:
> > +void arch_jump_label_transform(struct jump_entry *entry,
> > +                              enum jump_label_type type)
> > +{
> > +       union jump_code_union code;
> > +
> > +       if (type == JUMP_LABEL_ENABLE) {
> > +               code.jump = 0xe9;
> > +               code.offset = entry->target -
> > +                               (entry->code + JUMP_LABEL_NOP_SIZE);
> > +       } else
> > +               memcpy(&code, ideal_nop5, JUMP_LABEL_NOP_SIZE);
> > +       get_online_cpus();
> > +       mutex_lock(&text_mutex);
> > +       text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
> > +       mutex_unlock(&text_mutex);
> > +       put_online_cpus();
> > +} 
> 
> hpa, mathieu, what's the status of stop_machine less text poking?
> Because the above basically means we have to disable architecture
> jump_label support for -rt.

hpa got an unofficial answer from Intel OTC, that states the stop_machine-less
text poking procedure is valid.

http://lkml.org/lkml/2010/1/12/300

We are still waiting for the "official" blessing though.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
