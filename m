Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2KOJCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:02:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2KOJCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:02:07 -0500
Date: Thu, 15 Nov 2012 10:02:04 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 2/4] mm, oom: cleanup pagefault oom handler
Message-ID: <20121115090204.GA11990@dhcp22.suse.cz>
References: <alpine.DEB.2.00.1211140111190.32125@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1211140113020.32125@chino.kir.corp.google.com>
 <50A4AB9E.4030106@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A4AB9E.4030106@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-11-12 17:45:18, KAMEZAWA Hiroyuki wrote:
> (2012/11/14 18:15), David Rientjes wrote:
[...]
> >@@ -708,15 +671,17 @@ out:
> >
> >  /*
> >   * The pagefault handler calls here because it is out of memory, so kill a
> >- * memory-hogging task.  If a populated zone has ZONE_OOM_LOCKED set, a parallel
> >- * oom killing is already in progress so do nothing.  If a task is found with
> >- * TIF_MEMDIE set, it has been killed so do nothing and allow it to exit.
> >+ * memory-hogging task.  If any populated zone has ZONE_OOM_LOCKED set, a
> >+ * parallel oom killing is already in progress so do nothing.
> >   */
> >  void pagefault_out_of_memory(void)
> >  {
> >-	if (try_set_system_oom()) {
> >+	struct zonelist *zonelist = node_zonelist(first_online_node,
> >+						  GFP_KERNEL);
> 
> 
> why GFP_KERNEL ? not GFP_HIGHUSER_MOVABLE ?

I was wondering about the same but gfp_zonelist cares only about
__GFP_THISNODE so GFP_HIGHUSER_MOVABLE doesn't do any difference.
-- 
Michal Hocko
SUSE Labs
