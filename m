Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0KEI2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 04:28:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:54979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab0KEI2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 04:28:17 -0400
Message-ID: <4CD3BFEC.4080405@kernel.org>
Date: Fri, 05 Nov 2010 09:27:24 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] irq: use per_cpu kstat_irqs
References: <1288892908.2659.175.camel@edumazet-laptop>
In-Reply-To: <1288892908.2659.175.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Nov 2010 08:27:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 06:48 PM, Eric Dumazet wrote:
> Use modern per_cpu API to increment {soft|hard}irq counters, and
> use per_cpu allocation for (struct irq_desc)->kstats_irq instead of an
> array.
> 
> This gives better SMP/NUMA locality and saves few instructions per irq.
> 
> With small nr_cpuids values (8 for example), kstats_irq was a small
> array (less than L1_CACHE_BYTES), potentially source of false sharing.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Looks good to me although it would be nice to note the white space
fixes in the comment.

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
