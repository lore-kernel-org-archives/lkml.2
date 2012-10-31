Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422824Ab2JaNUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:20:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39947 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935567Ab2JaNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:20:27 -0400
Message-ID: <50912593.8050305@gmail.com>
Date: Wed, 31 Oct 2012 21:20:19 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: dipankar@in.ibm.com, Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org
Subject: Re: [PATCH 7/9] rcu:  use this_cpu_ptr per-cpu helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
References: <50910A17.1090600@gmail.com> <20121031115140.GX3027@linux.vnet.ibm.com>
In-Reply-To: <20121031115140.GX3027@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney said, at 2012/10/31 19:51:
> 
> The first uses smp_processor_id(), which will complain if
> force_quiescent_state() is called with preemption disabled, which it
> sometimes is.
> 
> So what am I missing here?

Hi Paul

this patch is not right for CONFIG_DEBUG_PREEMPT case.
__this_cpu_ptr is ok which do not check for preemption context.


> 
> 							Thanx, Paul
