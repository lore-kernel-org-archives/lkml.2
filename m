Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab2FOP2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:28:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:46162 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2FOP2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:28:36 -0400
Message-ID: <1339774107.2559.73.camel@twins>
Subject: Re: [PATCH V6 06/13] perf: Add Nehalem and Sandy Bridge uncore
 support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 17:28:27 +0200
In-Reply-To: <1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	 <1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
> @@ -808,6 +994,14 @@ static int __init uncore_cpu_init(void)
>         int ret, cpu;
>  
>         switch (boot_cpu_data.x86_model) {
> +       case 26: /* Nehalem */
> +       case 30:
> +       case 37: /* Westmere */
> +               msr_uncores = nhm_msr_uncores;
> +               break;
> +       case 42: /* Sandy Bridge */
> +               msr_uncores = snb_msr_uncores;
> +               break; 

What about WSP-EP (44)? Does it have an uncore similar to the regular
WSM (37) or WSM-EX / Xeon-E7 (47) ?

NHM-EX and WSM-EX are similar again, and not (yet) supported by these
patches, right?
