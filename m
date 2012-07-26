Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2GZJho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 05:37:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42609 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751206Ab2GZJhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 05:37:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18TyTIHE9QTjUYKlPRAc3gYU0Dp9B4zbgJEKNZKDF
	uysFxXUY2M1Fgt
Message-ID: <1343295457.6863.43.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] sched: recover SD_WAKE_AFFINE in
 select_task_rq_fair and code clean up
From: Mike Galbraith <efault@gmx.de>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com
Date: Thu, 26 Jul 2012 11:37:37 +0200
In-Reply-To: <1343280446-24019-1-git-send-email-alex.shi@intel.com>
References: <1343280446-24019-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 13:27 +0800, Alex Shi wrote:

> 	if (affine_sd) {
> -		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
> +		if (wake_affine(affine_sd, p, sync))
>  			prev_cpu = cpu;
>  
>  		new_cpu = select_idle_sibling(p, prev_cpu);

Hm, if cpu == prev_cpu, asking wake_affine() if it's ok to put wakee
back where it came from is wasted cycles.. that's where the task is
headed regardless of reply.

-Mike

