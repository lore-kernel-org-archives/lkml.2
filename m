Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab2EJMIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:08:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52316 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab2EJMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:08:33 -0400
Subject: Re: [tip:sched/core] x86/numa: Check for nonsensical topologies on
 real hw as well
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <1336650578.27020.94.camel@laptop>
References: <tip-re15l0jqjtpz709oxozt2zoh@git.kernel.org>
	 <CAE9FiQVu7KP=rabe5_jYZyEGpW7sv6wkK9wumJfW1vk2=+cYKA@mail.gmail.com>
	 <1336650578.27020.94.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 May 2012 14:08:24 +0200
Message-ID: <1336651704.27020.100.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 13:49 +0200, Peter Zijlstra wrote:
> +static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
> +{
> +       if (!topology_sane(c->cpu_index, o->cpu_index, "mc"))
> +               return false;
> +
> +       if (c->phys_proc_id == cpu_data(i).phys_proc_id)
> +               return true;
> +
> +       return false;
> +} 

Argh, that has the very same problem.. it (and the same for the other
two match funcions).

Something like:

  if (c->phys_proc_id == cpu_data(i).phys_proc_id && topology_sane())

might do, since then we only verify the topology after we would
otherwise have already accepted it.

