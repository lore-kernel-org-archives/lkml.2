Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0ETJuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:50:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41950 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0ETJuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:50:10 -0400
Subject: Re: [patch 6/7] sched: change nohz.load_balancer to be nr_cpu_ids
 based
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>
In-Reply-To: <20100517184028.032341083@sbs-t61.sc.intel.com>
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
	 <20100517184028.032341083@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 May 2010 11:49:29 +0200
Message-ID: <1274348969.5605.13741.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 11:27 -0700, Suresh Siddha wrote:
>  int get_nohz_load_balancer(void)
>  {
> -       return atomic_read(&nohz.load_balancer);
> +       int load_balancer = atomic_read(&nohz.load_balancer);
> +       if (load_balancer >= nr_cpu_ids)
> +               return nr_cpu_ids;
> +
> +       return load_balancer;
>  } 

How could it ever be > nr_cpu_ids, and thus, do we need that
conditional?
