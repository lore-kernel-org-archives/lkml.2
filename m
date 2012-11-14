Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2KNLDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:03:07 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49654 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2KNLDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:03:05 -0500
Date: Wed, 14 Nov 2012 03:03:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/4] mm, oom: ensure sysrq+f always passes valid
 zonelist
In-Reply-To: <20121114105049.GE17111@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.00.1211140254020.6949@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1211140111190.32125@chino.kir.corp.google.com> <20121114105049.GE17111@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Michal Hocko wrote:

> > With hotpluggable and memoryless nodes, it's possible that node 0 will
> > not be online, so use the first online node's zonelist rather than
> > hardcoding node 0 to pass a zonelist with all zones to the oom killer.
> 
> Makes sense although I haven't seen a machine with no 0 node yet.

We routinely do testing with them, actually, just by physically removing 
all memory described by the SRAT that maps to node 0.  You could do the 
same thing by making all pxms that map to node 0 to be hotpluggable in 
your memory affinity structure.  I've been bit by it one too many times so 
I always keep in mind that no single node id is guaranteed to be online 
(although at least one node is always online); hence, first_online_node is 
the solution.

> According to 13808910 this is indeed possible.
> 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> 

Thanks!
