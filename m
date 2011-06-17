Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1FQEYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 00:24:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:40387 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1FQEYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 00:24:40 -0400
Subject: Re: [PATCH] perf_events: Enable idle state tracing for pseries
 (ppc64)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: deepthi@linux.vnet.ibm.com
Cc: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110601123554.GA12492@deepthi.in.ibm.com>
References: <20110601123554.GA12492@deepthi.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 14:24:19 +1000
Message-ID: <1308284659.32158.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 18:05 +0530, Deepthi Dharwar wrote:
> Hi,
> 
> Please find below a patch, which has perf_events added for pseries (ppc64)
> platform in order to emit the trace required for perf timechart. 
> It essentially enables perf timechart for pseries platfrom to analyse
> power savings events like cpuidle states.

Unless I'm mistaken, you added traces to dedicated CPU idle sleep but
not shared processor. Any reason ?

Also I don't really know that tracing stuff but what's the point of
having start/end _and trace_cpu_idle if you're going to always start &
end around a single occurence of trace_cpu_idle ?

Wouldn't there be a way to start/end and then trace the snooze and
subsequent cede within the same start/end section or that makes no
sense ?

Also would there be any interest in doing the tracing more generically
in idle.c ?

Cheers,
Ben.

