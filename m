Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab1FWJGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:06:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35169 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab1FWJGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:06:05 -0400
Subject: Re: [patch 1/4] x86, mtrr: lock stop machine during MTRR
 rendezvous sequence
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, youquan.song@intel.com,
        stable@kernel.org
In-Reply-To: <20110622222043.862589370@sbsiddha-MOBL3.sc.intel.com>
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
	 <20110622222043.862589370@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 11:05:05 +0200
Message-ID: <1308819905.1022.70.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 15:20 -0700, Suresh Siddha wrote:
> +#ifdef CONFIG_SMP
> +       /*
> +        * If we are not yet online, then there can be no stop_machine() in
> +        * parallel. Stop machine ensures this by using get_online_cpus().
> +        *
> +        * If we are online, then we need to prevent a stop_machine() happening
> +        * in parallel by taking the stop cpus mutex.
> +        */
> +       if (cpu_online(raw_smp_processor_id()))
> +               mutex_lock(&stop_cpus_mutex);
> +#endif 

This reads like an optimization, is it really worth-while to not take
the mutex in the rare offline case?
