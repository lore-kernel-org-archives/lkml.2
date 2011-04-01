Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1DADSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 23:18:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44926 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1DADSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 23:18:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Cc: kosaki.motohiro@jp.fujitsu.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20110331214033.GA2904@dastard>
References: <20110330052819.8212.1359.stgit@localhost6.localdomain6> <20110331214033.GA2904@dastard>
Message-Id: <20110401121825.A875.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri,  1 Apr 2011 12:18:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Mar 30, 2011 at 11:00:26AM +0530, Balbir Singh wrote:
> > 
> > The following series implements page cache control,
> > this is a split out version of patch 1 of version 3 of the
> > page cache optimization patches posted earlier at
> > Previous posting http://lwn.net/Articles/425851/ and analysis
> > at http://lwn.net/Articles/419713/
> > 
> > Detailed Description
> > ====================
> > This patch implements unmapped page cache control via preferred
> > page cache reclaim. The current patch hooks into kswapd and reclaims
> > page cache if the user has requested for unmapped page control.
> > This is useful in the following scenario
> > - In a virtualized environment with cache=writethrough, we see
> >   double caching - (one in the host and one in the guest). As
> >   we try to scale guests, cache usage across the system grows.
> >   The goal of this patch is to reclaim page cache when Linux is running
> >   as a guest and get the host to hold the page cache and manage it.
> >   There might be temporary duplication, but in the long run, memory
> >   in the guests would be used for mapped pages.
> 
> What does this do that "cache=none" for the VMs and using the page
> cache inside the guest doesn't acheive? That avoids double caching
> and doesn't require any new complexity inside the host OS to
> acheive...

Right. 

"cache=none" has no double caching issue and KSM already solved
cross gues cache sharing. So, I _guess_ this is not a core motivation 
of his patch. But I'm not him. I'm not sure.


