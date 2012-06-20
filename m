Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2FTFxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:53:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37074 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2FTFxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <1340149411-2972-1-git-send-email-suresh.b.siddha@intel.com>
References: <1340067097.3696.6.camel@sbsiddha-desk.sc.intel.com>
	<1340149411-2972-1-git-send-email-suresh.b.siddha@intel.com>
Date: Tue, 19 Jun 2012 22:53:18 -0700
X-Google-Sender-Auth: wB_fVX7EwVwctH8EY_phBnzS8b4
Message-ID: <CAE9FiQXc_Sbm3uPi4YFQaR1a8DzWD1YCaZ2tiXupi9+ff=Smeg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, apic: optimize cpu traversal in
 __assign_irq_vector() using domain membership
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Alexander Gordeev <agordeev@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 4:43 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> Currently __assign_irq_vector() goes through each cpu in the specified mask
> until it finds a free vector in all the cpu's that are part of the same
> interrupt domain. We visit all the interrupt domain sibling cpus to reserve
> the free vector. So, when we fail to find a free vector in an interrupt
> domain, it is safe to continue our search with a cpu belonging to a new
> interrupt domain. No need to go through each cpu, if the domain
> containing that cpu is already visited.
>
> Use the irq_cfg's old_domain to track the visited domains and optimize
> the cpu traversal while finding a free vector in the given cpumask.
>
> NOTE: We can also optimize the search by using for_each_cpu and skip the
> current cpu, if it is not the first cpu in the mask returned by the
> vector_allocation_domain(). But re-using the cfg->old_domain to track
> the visited domains will be slightly faster.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>
