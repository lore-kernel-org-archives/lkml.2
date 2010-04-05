Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0DENzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 09:55:39 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:53818 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0DENzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 09:55:35 -0400
Date: Mon, 5 Apr 2010 08:54:49 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Tim C <tim.c.chen@intel.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
In-Reply-To: <1270195589.2078.116.camel@ymzhang.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1004050853300.23149@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>  <alpine.DEB.2.00.1003250942080.2670@router.home>  <1269570902.9614.92.camel@alexs-hp.sh.intel.com>  <1270114166.2078.107.camel@ymzhang.sh.intel.com>  <alpine.DEB.2.00.1004011050340.16531@router.home>
 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010, Zhang, Yanmin wrote:

> My testing command on my 2 socket machine:
> #hackbench 100 process 20000
>
> With 2.6.33, it takes for about 96 seconds while 2.6.34-rc2 (or the latest tip tree)
> takes for about 101 seconds.
>
> perf shows some functions around SLUB have more cpu utilization, while some other
> SLUB functions have less cpu utilization.

Hmnmmm... The dynamic percpu areas use page tables and that data is used
in the fast path. Maybe the high thread count causes tlb trashing?

