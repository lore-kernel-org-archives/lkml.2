Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab0JLBz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 21:55:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54519 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab0JLBzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 21:55:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [resend][PATCH] mm: increase RECLAIM_DISTANCE to 30
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>
In-Reply-To: <20101008090427.GB5327@balbir.in.ibm.com>
References: <20101008104852.803E.A69D9226@jp.fujitsu.com> <20101008090427.GB5327@balbir.in.ibm.com>
Message-Id: <20101012104701.AD2B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 Oct 2010 10:55:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > -#define RECLAIM_DISTANCE 20
> > +#define RECLAIM_DISTANCE 30
> >  #endif
> >  #ifndef PENALTY_FOR_NODE_WITH_CPUS
> >  #define PENALTY_FOR_NODE_WITH_CPUS	(1)
> 
> I am not sure if this makes sense, since RECLAIM_DISTANCE is supposed
> to be a hardware parameter. Could you please help clarify what the
> access latency of a node with RECLAIM_DISTANCE 20 to that of a node
> with RECLAIM_DISTANCE 30 is? Has the hardware definition of reclaim
> distance changed?

Recently, Intel/AMD implemented QPI/Hypertransport on their cpus. Then, 
commodity server's average node distance dramatically changed and our threshold
became typical case unfit.

So, my intention is, commodity server continue to don't use zone_reclaim_mode.
because their workload haven't been changed. 

30 itself don't have strong meaning.

> I suspect the side effect is the zone_reclaim_mode is not set to 1 on
> bootup for the 2-4 socket machines you mention, which results in
> better VM behaviour?

It depend on workload. If you are using file/web/emal server (i.e. most common case),
it's better. but HPC workload don't works so fine.



