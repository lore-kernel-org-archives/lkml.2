Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1BWX7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:59:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44478 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1BWX7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:59:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Feb 2011 08:52:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM
Message-Id: <20110224085227.1a3e185b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1298485162.7236.4.camel@nimitz>
References: <20110223151047.GA7275@tiehlicka.suse.cz>
	<1298485162.7236.4.camel@nimitz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 10:19:22 -0800
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Wed, 2011-02-23 at 16:10 +0100, Michal Hocko wrote:
> > We can reduce this internal fragmentation by splitting the single
> > page_cgroup array into more arrays where each one is well kmalloc
> > aligned. This patch implements this idea. 
> 
> How about using alloc_pages_exact()?  These things aren't allocated
> often enough to really get most of the benefits of being in a slab.
> That'll at least get you down to a maximum of about PAGE_SIZE wasted.  
> 

yes, alloc_pages_exact() is much better.

packing page_cgroups for multiple sections causes breakage in memory hotplug logic.

Thanks,
-Kame

