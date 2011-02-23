Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1BWSTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:19:33 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44859 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab1BWSTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:19:32 -0500
Subject: Re: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110223151047.GA7275@tiehlicka.suse.cz>
References: <20110223151047.GA7275@tiehlicka.suse.cz>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 23 Feb 2011 10:19:22 -0800
Message-ID: <1298485162.7236.4.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 16:10 +0100, Michal Hocko wrote:
> We can reduce this internal fragmentation by splitting the single
> page_cgroup array into more arrays where each one is well kmalloc
> aligned. This patch implements this idea. 

How about using alloc_pages_exact()?  These things aren't allocated
often enough to really get most of the benefits of being in a slab.
That'll at least get you down to a maximum of about PAGE_SIZE wasted.  

-- Dave

