Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1IZH3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:29:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:33864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1IZH3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:29:06 -0400
Subject: Re: [PATCH 4/5] mm: Only IPI CPUs to drain local pages if they exist
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Date: Mon, 26 Sep 2011 09:28:34 +0200
In-Reply-To: <1316940890-24138-5-git-send-email-gilad@benyossef.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	 <1316940890-24138-5-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317022114.9084.53.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-25 at 11:54 +0300, Gilad Ben-Yossef wrote:
> +static inline void inc_pcp_count(int cpu, struct per_cpu_pages *pcp, int count)
> +{
> +       if (unlikely(!total_cpu_pcp_count))

	if (unlikely(!__this_cpu_read(total_cpu_pco_count))

> +               cpumask_set_cpu(cpu, cpus_with_pcp);
> +
> +       total_cpu_pcp_count += count;

	__this_cpu_add(total_cpu_pcp_count, count);

> +       pcp->count += count;
> +}
> +
> +static inline void dec_pcp_count(int cpu, struct per_cpu_pages *pcp, int count)
> +{
> +       pcp->count -= count;
> +       total_cpu_pcp_count -= count;

	__this_cpu_sub(total_cpu_pcp_count, count);

> +
> +       if (unlikely(!total_cpu_pcp_count))

	if (unlikely(!__this_cpu_read(total_cpu_pcp_count))

> +               cpumask_clear_cpu(cpu, cpus_with_pcp);
> +} 


