Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0LWWSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:18:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:2223 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab0LWWSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:18:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=SLNKzPHiLAAo2gNccV2tOvkQnA5BKqunhPm0MLKdRSvNDiMJ7B0I2wudIpWt0h/WSB
         mgmDiMWOszi/lYrGOc2g==
Date: Thu, 23 Dec 2010 14:18:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Kyle McMartin <kyle@mcmartin.ca>, Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
 threshold when memory is low
In-Reply-To: <20101129155801.GG13268@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1012231413560.2116@chino.kir.corp.google.com>
References: <1288169256-7174-1-git-send-email-mel@csn.ul.ie> <1288169256-7174-2-git-send-email-mel@csn.ul.ie> <20101126160619.GP22651@bombadil.infradead.org> <20101129095618.GB13268@csn.ul.ie> <20101129131626.GF15818@bombadil.infradead.org>
 <20101129150824.GF13268@csn.ul.ie> <20101129152230.GH15818@bombadil.infradead.org> <20101129155801.GG13268@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Mel Gorman wrote:

> Andrew, this patch was a performance fix but is a report saying that it
> fixes a functional regression in Fedora enough to push a patch torwards
> stable even though an explanation as to *why* it fixes the problem is missing?
> 

We had to pull aa454840 "mm: page allocator: calculate a better estimate 
of NR_FREE_PAGES when memory is low and kswapd is awake" from 2.6.36 
internally because tests showed that it would cause the machine to stall 
as the result of heavy kswapd activity.  I merged it back with this fix as 
it is pending in the -mm tree and it solves the issue we were seeing, so I 
definitely think this should be pushed to -stable (and I would seriously 
consider it for 2.6.37 inclusion even at this late date).
