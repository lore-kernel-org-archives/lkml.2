Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1J1QIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 12:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1J1QII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 12:08:08 -0400
Message-ID: <4EAAD351.70805@redhat.com>
Date: Fri, 28 Oct 2011 12:07:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v2 4/6] mm: Only IPI CPUs to drain local pages if they
 exist
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com> <1319385413-29665-5-git-send-email-gilad@benyossef.com>
In-Reply-To: <1319385413-29665-5-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2011 11:56 AM, Gilad Ben-Yossef wrote:
> Use a cpumask to track CPUs with per-cpu pages in any zone
> and only send an IPI requesting CPUs to drain these pages
> to the buddy allocator if they actually have pages.

> +/* Which CPUs have per cpu pages  */
> +cpumask_var_t cpus_with_pcp;
> +static DEFINE_PER_CPU(unsigned long, total_cpu_pcp_count);

Does the flushing happen so frequently that it is worth keeping this
state on a per-cpu basis, or would it be better to check each CPU's
pcp info and assemble a cpumask at flush time like done in patch 5?



-- 
All rights reversed
