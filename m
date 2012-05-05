Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab2EEBss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 21:48:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53826 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453Ab2EEBsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 21:48:40 -0400
Date: Fri, 4 May 2012 18:47:14 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linaro-kernel@lists.linaro.org, patches@linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] cpu: Introduce clear_tasks_mm_cpumask() helper
Message-ID: <20120505014711.GA24566@lizard>
References: <20120423070641.GA27702@lizard>
 <20120423070736.GA30752@lizard>
 <20120426165911.00cebd31.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120426165911.00cebd31.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 04:59:11PM -0700, Andrew Morton wrote:
[...]
> > 	 so its not like new tasks will ever get this cpu set in
> > +	 * their mm mask. -- Peter Zijlstra
> > +	 * Thus, we may use rcu_read_lock() here, instead of grabbing
> > +	 * full-fledged tasklist_lock.
> > +	 */
> > +	rcu_read_lock();
> > +	for_each_process(p) {
> > +		struct task_struct *t;
> > +
> > +		t = find_lock_task_mm(p);
> > +		if (!t)
> > +			continue;
> > +		cpumask_clear_cpu(cpu, mm_cpumask(t->mm));
> > +		task_unlock(t);
> > +	}
> > +	rcu_read_unlock();
> > +}
> 
> It is good that this code exists under CONFIG_HOTPLUG_CPU.  Did you
> check that everything works correctly with CONFIG_HOTPLUG_CPU=n?

Yeah, only the code under CONFIG_HOTPLUG_CPU calls the function, so
it should be all fine.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
