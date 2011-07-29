Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1G2Q7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:59:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1G2Q7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:59:11 -0400
Subject: Re: [PATCH 2/7] perf, x86: Implement IBS initialization
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1311860812-28748-3-git-send-email-robert.richter@amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311860812-28748-3-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Jul 2011 18:58:45 +0200
Message-ID: <1311958725.5890.410.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> +static int perf_ibs_add(struct perf_event *event, int flags)
> +{
> +       pr_info("Adding event %p (config=%016llx) to pmu %s (type=%d) on cpu %d\n",
> +               event, event->attr.config, perf_ibs.name, event->attr.type, event->oncpu);
> +       return 0;
> +}
> +
> +static void perf_ibs_del(struct perf_event *event, int flags)
> +{
> +       pr_info("Removing event %p (config=%016llx) to pmu %s (type=%d) on cpu %d\n",
> +               event, event->attr.config, perf_ibs.name, event->attr.type, event->oncpu);
> +} 

While I see you remove them later on, I do find it somewhat strange to
have them here. This is user triggerable code in the context switch
path, lots of nasty can come from this.
