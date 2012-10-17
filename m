Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2JQWMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:12:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2JQWMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:12:36 -0400
Date: Wed, 17 Oct 2012 15:12:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 11/14] memcg: allow a memcg with kmem charges to be
 destructed.
Message-Id: <20121017151235.1e5d6f21.akpm@linux-foundation.org>
In-Reply-To: <1350382611-20579-12-git-send-email-glommer@parallels.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
	<1350382611-20579-12-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 14:16:48 +0400
Glauber Costa <glommer@parallels.com> wrote:

> Because the ultimate goal of the kmem tracking in memcg is to track slab
> pages as well,

It is?  For a major patchset such as this, it's pretty important to
discuss such long-term plans in the top-level discussion.  Covering
things such as expected complexity, expected performance hit, how these
plans affected the current implementation, etc.

The main reason for this is that if the future plans appear to be of
doubtful feasibility and the current implementation isn't sufficiently
useful without the future stuff, we shouldn't merge the current
implementation.  It's a big issue!

> we can't guarantee that we'll always be able to point a
> page to a particular process, and migrate the charges along with it -
> since in the common case, a page will contain data belonging to multiple
> processes.
> 
> Because of that, when we destroy a memcg, we only make sure the
> destruction will succeed by discounting the kmem charges from the user
> charges when we try to empty the cgroup.
> 
> ...
>
