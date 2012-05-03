Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2ECVkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:40:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60114 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab2ECVkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:40:08 -0400
Message-ID: <1336081192.6509.29.camel@twins>
Subject: Re: [PATCH 6/9] perf: Generic pci uncore device support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 23:39:52 +0200
In-Reply-To: <1335924440-11242-7-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-7-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
> +       uncores = msr_uncores;
> +       while (1) {
> +               for (i = 0; uncores[i]; i++) {
> +                       type = uncores[i];
> +                       for (j = 0; j < type->num_boxes; j++) {
> +                               pmu = &type->pmus[j];
> +                               box = uncore_pmu_find_box(pmu, phyid);
> +                               WARN_ON_ONCE(box->cpu != -1);
> +                               box->cpu = cpu;
> +                       }
>                 }
> +               if (uncores != msr_uncores)
> +                       break;
> +               uncores = pci_uncores;
>         } 

Wouldn't it be better to pull the body out into a separate function and
do something like:

 __uncore_init_types(msr_uncores, cpu);
 __uncore_init_types(pci_uncores, cpu);

same for the other such construct..


