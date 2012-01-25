Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2AYPiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:38:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35092 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2AYPiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:38:19 -0500
Subject: Re: [RFC PATCH v1 2/2] sched: fix group_capacity for thread level
 consolidation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20120116162255.29759.6264.stgit@localhost>
References: <20120116161740.29759.4679.stgit@localhost>
	 <20120116162255.29759.6264.stgit@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 16:38:06 +0100
Message-ID: <1327505886.2614.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 21:52 +0530, Vaidyanathan Srinivasan wrote:
> +               /*
> +                * If power savings balance is set at this domain, then
> +                * make capacity equal to number of hardware threads to
> +                * accommodate more tasks until capacity is reached.
> +                */
> +               else if (sd->flags & SD_POWERSAVINGS_BALANCE)
> +                       sgs.group_capacity =
> +                               cpumask_weight(sched_group_cpus(sg)); 

sg->group_weight perhaps?

