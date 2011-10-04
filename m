Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1JDBWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 21:22:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53174 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab1JDBWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 21:22:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 4 Oct 2011 10:21:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        ebiederm@xmission.com, davem@davemloft.net, gthelen@google.com,
        netdev@vger.kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        avagin@parallels.com
Subject: Re: [PATCH v4 6/8] tcp buffer limitation: per-cgroup limit
Message-Id: <20111004102114.08b06ae8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317637123-18306-7-git-send-email-glommer@parallels.com>
References: <1317637123-18306-1-git-send-email-glommer@parallels.com>
	<1317637123-18306-7-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Oct 2011 14:18:41 +0400
Glauber Costa <glommer@parallels.com> wrote:

> This patch uses the "tcp_max_mem" field of the kmem_cgroup to
> effectively control the amount of kernel memory pinned by a cgroup.
> 
> We have to make sure that none of the memory pressure thresholds
> specified in the namespace are bigger than the current cgroup.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  Documentation/cgroups/memory.txt |    1 +
>  include/linux/memcontrol.h       |   10 +++++
>  include/net/tcp.h                |    1 +
>  mm/memcontrol.c                  |   76 +++++++++++++++++++++++++++++++++++---
>  net/ipv4/sysctl_net_ipv4.c       |   20 ++++++++++
>  5 files changed, 102 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 6f1954a..1ffde3e 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -78,6 +78,7 @@ Brief summary of control files.
>  
>   memory.independent_kmem_limit	 # select whether or not kernel memory limits are
>  				   independent of user limits
> + memory.kmem.tcp.max_memory      # set/show hard limit for tcp buf memory
>  

What is the releationship between tcp.max_memory and kmem_limit ?

tcp.max_memory < kmem_limit ?
usage of tcp memory is included in kmem usage ?


Thanks,
-Kame

