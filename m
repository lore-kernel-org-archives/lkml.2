Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0E2Bjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 21:39:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:43355 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0E2Bjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 21:39:47 -0400
Date: Fri, 28 May 2010 18:42:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Renninger <trenn@suse.de>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org,
       robert.schoene@tu-dresden.de, cpufreq@vger.kernel.org,
       linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org,
       x86@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] x86 cpufreq: Make trace_power_frequency cpufreq driver
 independent
Message-ID: <20100528184213.76c09515@infradead.org>
In-Reply-To: <1274791199-12335-1-git-send-email-trenn@suse.de>
References: <1274791199-12335-1-git-send-email-trenn@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 14:39:59 +0200
Thomas Renninger <trenn@suse.de> wrote:

> and fix the broken case if a core's frequency depends on others.
> 
> trace_power_frequency was only implemented in a rather ungeneric way
> in acpi-cpufreq driver's target() function only.
> -> Move the call to trace_power_frequency to
>    cpufreq.c:cpufreq_notify_transition() where CPUFREQ_POSTCHANGE
>    notifier is triggered.
>    This will support power frequency tracing by all cpufreq drivers
> 
> trace_power_frequency did not trace frequency changes correctly when
> the userspace governor was used or when CPU cores' frequency depend
> on each other.
> -> Moving this into the CPUFREQ_POSTCHANGE notifier and pass the cpu
>    which gets switched automatically fixes this.


while I'm no great fan of having a second field in the perf structure
for the cpu... I can see that Thomas has a use case where this solves
his issue...

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
