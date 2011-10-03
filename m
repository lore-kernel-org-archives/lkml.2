Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1JCKFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:05:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35874 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1JCKFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:05:14 -0400
Subject: Re: [PATCH] CPU hotplug, freezer: Fix bugs in CPU hotplug call path
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, len.brown@intel.com,
        mingo@elte.hu, akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@lists.linux-foundation.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E88BF33.10407@linux.vnet.ibm.com>
References: <4E88BF33.10407@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Oct 2011 12:03:35 +0200
Message-ID: <1317636215.12973.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 01:14 +0530, Srivatsa S. Bhat wrote:
> +static atomic_t tasks_frozen = ATOMIC_INIT(0);
> +
> +void set_tasks_frozen_flag(void)
> +{
> +       atomic_set(&tasks_frozen, 1);
> +}
> +
> +void clear_tasks_frozen_flag(void)
> +{
> +       atomic_set(&tasks_frozen, 0);
> +}
> +
> +int tasks_are_frozen(void)
> +{
> +       int ret;
> +       ret = atomic_read(&tasks_frozen);
> +       return ret;
> +} 

What's the point of using atomic_t here? Neither set nor read are
actually atomic ops.
