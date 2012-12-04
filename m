Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2LDPRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:17:45 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50922 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2LDPRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:17:43 -0500
Date: Tue, 4 Dec 2012 07:17:34 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/10] CPU hotplug: Introduce "stable" cpu online
 mask, for atomic hotplug readers
Message-ID: <20121204151734.GB3885@mtj.dyndns.org>
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
 <20121204085324.25919.53090.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121204085324.25919.53090.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Srivatsa.

On Tue, Dec 04, 2012 at 02:23:41PM +0530, Srivatsa S. Bhat wrote:
>  extern const struct cpumask *const cpu_possible_mask;
>  extern const struct cpumask *const cpu_online_mask;
> +extern const struct cpumask *const cpu_online_stable_mask;
>  extern const struct cpumask *const cpu_present_mask;
>  extern const struct cpumask *const cpu_active_mask;

This is a bit nasty.  The distinction between cpu_online_mask and the
stable one is quite subtle and there's no mechanism to verify the
right one is in use.  IIUC, the only time cpu_online_mask and
cpu_online_stable_mask can deviate is during the final stage CPU take
down, right?  If so, why not just make cpu_online_mask the stable one
and the few cases where the actual online state matters deal with the
internal version?  Anyone outside cpu hotplug proper should be happy
with the stable version anyway, no?

Thanks.

-- 
tejun
