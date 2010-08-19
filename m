Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0HSTDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 15:03:50 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:39665 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752736Ab0HSTDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:03:47 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lOFIvAoVM1kFub0Q8CiEjxqACnm1Xx7IpC5HgHKvsERI4DJ
 gesz4yLFgntaWveEWf7FrBLXIY7D0pkIsLHaMay5OD5x5zC2bz84SoqvReFP
 KS9rzmBbMPWVJw0Rjxo297ZZdZMIShFZtLehyMjDYZViGRoBYMjNE2JETfcO
 5mF1Y2ZmX2U9LCLWNO9HgQ6TDyN0qAhCiDukNE0uO_5Bomip._UCt95ZKjbV
 K
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 19 Aug 2010 14:03:42 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Chris Webb <chris@arachsys.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Over-eager swapping
In-Reply-To: <20100819102055.GK2370@arachsys.com>
Message-ID: <alpine.DEB.2.00.1008191402050.1839@router.home>
References: <20100804032400.GA14141@localhost> <20100804095811.GC2326@arachsys.com> <20100804114933.GA13527@localhost> <20100804120430.GB23551@arachsys.com> <20100818143801.GA9086@localhost> <20100818144655.GX2370@arachsys.com> <20100818152103.GA11268@localhost>
 <1282147034.77481.33.camel@useless.localdomain> <20100818155825.GA2370@arachsys.com> <alpine.DEB.2.00.1008181112510.6294@router.home> <20100819102055.GK2370@arachsys.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010, Chris Webb wrote:

> I tried this on a handful of the problem hosts before re-adding their swap.
> One of them now runs without dipping into swap. The other three I tried had
> the same behaviour of sitting at zero swap usage for a while, before
> suddenly spiralling up with %wait going through the roof. I had to swapoff
> on them to bring them back into a sane state. So it looks like it helps a
> bit, but doesn't cure the problem.
>
> I could definitely believe an explanation that we're swapping in preference
> to allocating remote zone pages somehow, given the imbalance in free memory
> between the nodes which we saw. However, I read the documentation for
> vm.zone_reclaim_mode, which suggests to me that when it was set to zero,
> pages from remote zones should be allocated automatically in preference to
> swap given that zone_reclaim_mode & 4 == 0?

If zone reclaim is off then pages from other nodes will be allocated if a
node is filled up with page cache.

zone reclaim typically only evicts clean page cache pages in order to keep
the additional overhead down. Enabling swapping allows a more aggressive
form of recovering memory in preference of going off line.

The VM should work fine even without zone reclaim.
