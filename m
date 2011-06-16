Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab1FPSqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:46:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49576 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1FPSqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:46:34 -0400
Subject: Re: mmotm 2011-06-15-16-56 uploaded (mm/page_cgroup.c)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20110616165146.GB5244@suse.de>
References: <201106160034.p5G0Y4dr028904@imap1.linux-foundation.org>
	 <20110615214917.a7dce8e6.randy.dunlap@oracle.com>
	 <20110616172819.1e2d325c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20110616103559.GA5244@suse.de> <1308241542.11430.119.camel@nimitz>
	 <20110616165146.GB5244@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 11:46:04 -0700
Message-ID: <1308249964.11430.157.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 17:51 +0100, Mel Gorman wrote:
> No, why was node_start_pfn() and node_end_pfn() defined optionally
> on a per-architecture basis?

Probably because it started in the NUMA-Q port, and we were still trying
to stay off the radar at that point.  It looks like it showed up in
~2.5.[3-4]?.  We didn't know what the heck we were doing back then, and
it probably leaked out from under CONFIG_NUMA/DISCONTIGMEM at some
point.

Seems like a good thing to consolidate to me.  Especially since it's
just a shortcut to the (unconditionally defined) structure member, I
can't see a real justification for needing different definitions.

-- Dave

