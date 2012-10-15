Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab2JOJEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:04:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37013 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2JOJEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:04:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <507BD1A3.3040004@jp.fujitsu.com>
Date: Mon, 15 Oct 2012 18:04:35 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: linux-mm@kvack.org, Dave Hansen <dave@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
References: <20121012125708.GJ10110@dhcp22.suse.cz>
In-Reply-To: <20121012125708.GJ10110@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/12 21:57), Michal Hocko wrote:
> Hi,
> I would like to resurrect the following Dave's patch. The last time it
> has been posted was here https://lkml.org/lkml/2010/9/16/250 and there
> didn't seem to be any strong opposition.
> Kosaki was worried about possible excessive logging when somebody drops
> caches too often (but then he claimed he didn't have a strong opinion
> on that) but I would say opposite. If somebody does that then I would
> really like to know that from the log when supporting a system because
> it almost for sure means that there is something fishy going on. It is
> also worth mentioning that only root can write drop caches so this is
> not an flooding attack vector.
> I am bringing that up again because this can be really helpful when
> chasing strange performance issues which (surprise surprise) turn out to
> be related to artificially dropped caches done because the admin thinks
> this would help...
>
> I have just refreshed the original patch on top of the current mm tree
> but I could live with KERN_INFO as well if people think that KERN_NOTICE
> is too hysterical.
> ---
>  From 1f4058be9b089bc9d43d71bc63989335d7637d8d Mon Sep 17 00:00:00 2001
> From: Dave Hansen <dave@linux.vnet.ibm.com>
> Date: Fri, 12 Oct 2012 14:30:54 +0200
> Subject: [PATCH] add some drop_caches documentation and info messsge
>
> There is plenty of anecdotal evidence and a load of blog posts
> suggesting that using "drop_caches" periodically keeps your system
> running in "tip top shape".  Perhaps adding some kernel
> documentation will increase the amount of accurate data on its use.
>
> If we are not shrinking caches effectively, then we have real bugs.
> Using drop_caches will simply mask the bugs and make them harder
> to find, but certainly does not fix them, nor is it an appropriate
> "workaround" to limit the size of the caches.
>
> It's a great debugging tool, and is really handy for doing things
> like repeatable benchmark runs.  So, add a bit more documentation
> about it, and add a little KERN_NOTICE.  It should help developers
> who are chasing down reclaim-related bugs.
>
> [mhocko@suse.cz: refreshed to current -mm tree]
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


