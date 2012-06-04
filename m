Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab2FDKdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:33:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36731 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2FDKdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:33:00 -0400
Message-ID: <1338805967.28282.12.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 12:32:47 +0200
In-Reply-To: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 14:24 +0400, Vladimir Davydov wrote:
> rq->cpuload strongly depends on cgroup hierarchy. For example, if hundreds of
> tasks are running inside cpu:/test cgroup, the sum of cpuload over all cpus
> won't exceed 1024 (by default). That makes the cpuidle menu governor take wrong
> decisions, which can negatively affect overall performance.
> 
> To cope this, use nr_running last seen in __update_cpu_load() instead of
> cpuload for calculating performance multiplier.

What is cpuidle trying to do?
