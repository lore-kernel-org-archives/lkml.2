Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0DNXhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:37:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:35130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab0DNXhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:37:08 -0400
Message-ID: <4BC65237.5080408@kernel.org>
Date: Thu, 15 Apr 2010 08:39:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com> <d5d70d4b57376bc89f178834cf0e424eaa681ab4.1271171877.git.minchan.kim@gmail.com> <20100413154820.GC25756@csn.ul.ie>
In-Reply-To: <20100413154820.GC25756@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 23:36:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/14/2010 12:48 AM, Mel Gorman wrote:
> and the mapping table on x86 at least is based on possible CPUs in
> init_cpu_to_node() leaves the mapping as 0 if the APIC is bad or the numa
> node is reported in apicid_to_node as -1. It would appear on power that
> the node will be 0 for possible CPUs as well.
> 
> Hence, I believe this to be safe but a confirmation from Tejun would be
> nice. I would continue digging but this looks like an initialisation path
> so I'll move on to the next patch rather than spending more time.

This being a pretty cold path, I don't really see much benefit in
converting it to alloc_pages_node_exact().  It ain't gonna make any
difference.  I'd rather stay with the safer / boring one unless
there's a pressing reason to convert.

Thanks.

-- 
tejun
