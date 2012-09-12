Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab2ILOWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:22:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49172 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758803Ab2ILOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:22:29 -0400
Subject: Re: [PATCH v2 1/3] hrtimer: add hrtimer_init_cpu()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, zheng.z.yan@intel.com, robert.richter@amd.com
In-Reply-To: <1347459195-5491-2-git-send-email-eranian@google.com>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	 <1347459195-5491-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Sep 2012 16:22:24 +0200
Message-ID: <1347459744.13103.1033.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-12 at 16:13 +0200, Stephane Eranian wrote:

>  void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t clock_id,
>  			   enum hrtimer_mode mode)
>  {
>  	debug_object_init_on_stack(timer, &hrtimer_debug_descr);
> -	__hrtimer_init(timer, clock_id, mode);
> +	__hrtimer_init(smp_processor_id(), timer, clock_id, mode);
>  }

This assumes caller is in non preemptable context.



