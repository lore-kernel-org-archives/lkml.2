Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1IZBrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 21:47:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:18896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab1IZBrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 21:47:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,441,1312182000"; 
   d="scan'208";a="55486944"
Subject: Re: [PATCH 4/5] mm: Only IPI CPUs to drain local pages if they
 exist
From: Shaohua Li <shaohua.li@intel.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
In-Reply-To: <1316940890-24138-5-git-send-email-gilad@benyossef.com>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	 <1316940890-24138-5-git-send-email-gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 09:52:04 +0800
Message-ID: <1317001924.29510.160.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-25 at 16:54 +0800, Gilad Ben-Yossef wrote:
> Use a cpumask to track CPUs with per-cpu pages in any zone
> and only send an IPI requesting CPUs to drain these pages
> to the buddy allocator if they actually have pages.
Did you have evaluation why the fine-grained ipi is required? I suppose
every CPU has local pages here.

