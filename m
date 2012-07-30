Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2G3MtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:49:03 -0400
Received: from shutemov.name ([176.9.204.213]:44335 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab2G3MtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:49:02 -0400
Date: Mon, 30 Jul 2012 15:50:04 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        cgroups@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 04/10] memcg: skip memcg kmem allocations in specified
 code regions
Message-ID: <20120730125004.GA27293@shutemov.name>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com>
 <1343227101-14217-5-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343227101-14217-5-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 06:38:15PM +0400, Glauber Costa wrote:
> This patch creates a mechanism that skip memcg allocations during
> certain pieces of our core code. It basically works in the same way
> as preempt_disable()/preempt_enable(): By marking a region under
> which all allocations will be accounted to the root memcg.
> 
> We need this to prevent races in early cache creation, when we
> allocate data using caches that are not necessarily created already.

Why not a GFP_* flag?

-- 
 Kirill A. Shutemov
