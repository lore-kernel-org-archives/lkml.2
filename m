Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2BVNzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:55:21 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:48196 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751585Ab2BVNzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:55:20 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4zsRZIAVM1lMmj9gvgPQSnJLQ7UnSIZDKwLjCs7Ut65jCa8
 R8Od29c9OLSCQVzHYnlUGJ3APfj3tLHkvOaa1Ugu2AEgP3XGb40ZFCHbdVHZ
 wqcPqDL_CIiirEans6ysf34hfIlv1rHzgUGSIUC11z7dOV_CwGi1JynSI5L7
 mFeu4ozkYeBZn7ZgO8WMYsVIYim3v9C6ImVK_VnLiKR3hPzjwF6ODHR9d4WO
 iH7KoGwQeqLapc_SSYrY3LwxaJILOltW5_qIw_SRXs9Bxh88c6JPjFpKa2h3
 RrdISCHoS22S_.njG_rfhLXUzByfzfV7TkeMw72axV_JKs.1GU96yxjj.W3c
 ugA9UmFjzOq.oAdMmEmdypv0d2BUCyN3DUyPiIktBbFwYpG0tw.2ZuujtWiK
 r
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 22 Feb 2012 07:55:16 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Rafael Aquini <aquini@redhat.com>
cc: linux-mm@kvack.org, Randy Dunlap <rdunlap@xenotime.net>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
In-Reply-To: <20120222115320.GA3107@x61.redhat.com>
Message-ID: <alpine.DEB.2.00.1202220754140.21637@router.home>
References: <20120222115320.GA3107@x61.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Feb 2012, Rafael Aquini wrote:

> --- a/mm/slub.c
> +++ b/mm/slub.c
> +void oom_dump_slabs(int ratio)
> +{

> +
> +		for_each_online_node(node) {
> +			struct kmem_cache_node *n = get_node(cachep, node);
> +			if (!n)
> +				continue;
> +
> +			nr_objs += atomic_long_read(&n->total_objects);

Please use node_nr_objects() instead of directly accessing total_objects.
total_objects are only available if debugging support was compiled in.

