Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab1LOQOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:14:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47174 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1LOQOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:14:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Dec 2011 01:13:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/2] Explicitly call tcp creation and init from
 memcontrol.c
Message-Id: <20111216011316.8d58bc8f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1323941672-14324-3-git-send-email-glommer@parallels.com>
References: <1323941672-14324-1-git-send-email-glommer@parallels.com>
	<1323941672-14324-3-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011 13:34:32 +0400
Glauber Costa <glommer@parallels.com> wrote:

> Walking the proto_list holds a read_lock, which prevents us from doing
> allocations. Splitting the tcp create function into create + init is
> good, but it is not enough since create_files will do allocations as well
> (dentry ones, mostly).
> 
> Since this does not involve any protocol state, I propose we call the tcp
> functions explicitly from memcontrol.c
> 
> With this, we lose by now the ability of doing cgroup memcontrol for
> protocols that are loaded as modules. But at least the ones I have in mind
> won't really need it (tcp_ipv6 being the only one, but it uses the same data
> structures as tcp_ipv4). So I believe this to be the simpler solution to this
> problem.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Stephen Rothwell <sfr@canb.auug.org.au>

Could you remake the patch onto the 'latest' linux-next ?
As Dave mentioned, some bandaids are already applied and this patch hunks.

Thanks,
-Kame

