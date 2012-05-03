Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab2ECVEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:04:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:46683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab2ECVEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:04:37 -0400
Message-ID: <1336079060.6509.17.camel@twins>
Subject: Re: [PATCH 5/9] perf: Add Nehalem and Sandy Bridge uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 23:04:20 +0200
In-Reply-To: <1335924440-11242-6-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-6-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
>         switch (boot_cpu_data.x86_model) {
> +       case 26: /* Nehalem */
> +       case 30:
> +       case 31:
> +       case 37: /* Westmere */
> +               msr_uncores = nhm_msr_uncores;
> +               break;
> +       case 42: /* Sandy Bridge */
> +               msr_uncores = snb_msr_uncores;
> +               break;
>         default:
>                 return 0;
>         } 

I really hate we're duplicating all these things all over the place, but
I don't really know what to do about it either.

Anyway, it looks like perf_event_intel.c is missing 31, that said I
cannot seem to find model 31 on wikipedia either.

What about 44, WSM-EP ?

I understand NHM-EX (46) and WSM-EX (47) have different uncores not
implemented in this series, will those follow?
