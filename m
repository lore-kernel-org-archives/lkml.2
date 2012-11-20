Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2KTR1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:27:11 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34634 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab2KTR1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:27:10 -0500
Date: Tue, 20 Nov 2012 12:27:00 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, memcg: avoid unnecessary function call when memcg is
 disabled
Message-ID: <20121120172700.GA21703@cmpxchg.org>
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 05:44:34PM -0800, David Rientjes wrote:
> While profiling numa/core v16 with cgroup_disable=memory on the command 
> line, I noticed mem_cgroup_count_vm_event() still showed up as high as 
> 0.60% in perftop.
> 
> This occurs because the function is called extremely often even when memcg 
> is disabled.
> 
> To fix this, inline the check for mem_cgroup_disabled() so we avoid the 
> unnecessary function call if memcg is disabled.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
