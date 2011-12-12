Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1LLAgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 19:36:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36165 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1LLAgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 19:36:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 12 Dec 2011 09:34:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <lizf@cn.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>, <eric.dumazet@gmail.com>,
        <cgroups@vger.kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH v8 1/9] Basic kernel memory functionality for the Memory
 Controller
Message-Id: <20111212093448.91c96f77.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4EE21D23.4000309@parallels.com>
References: <1323120903-2831-1-git-send-email-glommer@parallels.com>
	<1323120903-2831-2-git-send-email-glommer@parallels.com>
	<20111209102113.cdb85da8.kamezawa.hiroyu@jp.fujitsu.com>
	<4EE21D23.4000309@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011 12:37:23 -0200
Glauber Costa <glommer@parallels.com> wrote:

> On 12/08/2011 11:21 PM, KAMEZAWA Hiroyuki wrote:
> > Hm, why you check val != parent->kmem_independent_accounting ?
> >
> > 	if (parent&&  parent->use_hierarchy)
> > 		return -EINVAL;
> > ?
> >
> > BTW, you didn't check this cgroup has children or not.
> > I think
> >
> > 	if (this_cgroup->use_hierarchy&&
> >               !list_empty(this_cgroup->childlen))
> > 		return -EINVAL;
> 
> How about this?
> 
>          val = !!val;
> 
>          /*
>           * This follows the same hierarchy restrictions than
>           * mem_cgroup_hierarchy_write()
>           */
>          if (!parent || !parent->use_hierarchy) {
>                  if (list_empty(&cgroup->children))
>                          memcg->kmem_independent_accounting = val;
>                  else
>                          return -EBUSY;
>          }
>          else
>                  return -EINVAL;
> 
>          return 0;
> 
seems good to me.

Thanks,
-Kame

