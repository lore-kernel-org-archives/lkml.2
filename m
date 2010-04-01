Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab0DAPxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:53:42 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:56233 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab0DAPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:53:36 -0400
Date: Thu, 1 Apr 2010 10:53:21 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       "Tim C <tim.c.chen"@intel.com, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
In-Reply-To: <1270114166.2078.107.camel@ymzhang.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1004011050340.16531@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>  <alpine.DEB.2.00.1003250942080.2670@router.home>  <1269570902.9614.92.camel@alexs-hp.sh.intel.com> <1270114166.2078.107.camel@ymzhang.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Zhang, Yanmin wrote:

> I suspect the moving of place of cpu_slab in kmem_cache causes the new cache
> miss. But when I move it to the tail of the structure, kernel always panic when
> booting. Perhaps there is another potential bug?

Why would that cause an additional cache miss?


The node array is following at the end of the structure. If you want to
move it down then it needs to be placed before the node field.
