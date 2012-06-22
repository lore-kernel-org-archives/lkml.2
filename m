Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761792Ab2FVJAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:00:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761768Ab2FVJAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:00:34 -0400
Date: Fri, 22 Jun 2012 11:00:20 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, gorcunov@openvz.org
Subject: Re: [PATCH v2 3/3] x86, x2apic: use multiple cluster members for the
 irq destination only with the explicit affinity
Message-ID: <20120622090019.GF2223@dhcp-26-207.brq.redhat.com>
References: <1340316145-4431-1-git-send-email-suresh.b.siddha@intel.com>
 <1340316145-4431-4-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340316145-4431-4-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 03:02:25PM -0700, Suresh Siddha wrote:
> +	if (mask == x2apic_cluster_target_cpus())
> +		cpumask_copy(retmask, cpumask_of(cpu));
> +	else
> +		cpumask_and(retmask, mask, per_cpu(cpus_in_cluster, cpu));
>  }

Yay, target_cpus() is a way better here.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
