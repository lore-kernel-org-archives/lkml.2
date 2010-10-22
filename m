Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab0JVACy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:02:54 -0400
Received: from ozlabs.org ([203.10.76.45]:47839 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560Ab0JVACx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:02:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Finishing off cpumask...
Date: Fri, 22 Oct 2010 10:32:42 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>, anton@samba.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <201010211735.23918.rusty@rustcorp.com.au> <1287652907.3488.64.camel@twins>
In-Reply-To: <1287652907.3488.64.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221032.42687.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 07:51:47 pm Peter Zijlstra wrote:
> On Thu, 2010-10-21 at 17:35 +1030, Rusty Russell wrote:
> > The next two turn off and break
> > old-style cpumask uses when CONFIG_CPUMASK_OFFSTACK is set, 
> 
> Breaking old style for !CONFIG_CPUMASK_OFFSTAK too would be awesome, but
> I guess that's hard to do?

There are four things we could do.
(1) Get rid of the old cpus_ operators (=> cpumask_*).  They're just
    confusing, and  removing them would be a clarity win.
(2) Get rid of cpu_*_map (=> cpu_*_mask).  The maps are just wrappers.
(3) Getting rid of cpumask_t (=> struct cpumask) and NR_CPUS
    (=> CONFIG_NR_CPUS). These are totally cosmetic.
(4) Getting rid of cpumask_t/struct cpumask (=> cpumask_var_t) is basically
    only useful if an arch is thinking about CPUMASK_OFFSTACK, and most
    painful.

So, I've changed the CONFIG option which disables (1) and (2); now anyone
will be able to turn it on if they want to test.  That might encourage
the per-arch cleanup...

Thanks,
Rusty.
