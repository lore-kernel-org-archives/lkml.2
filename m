Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab1LMN7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:59:22 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37516 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab1LMN7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:59:16 -0500
Message-ID: <1323784748.2950.4.camel@edumazet-laptop>
Subject: Re: [PATCH v9 0/9] Request for inclusion: per-cgroup tcp memory
 pressure controls
From: Eric Dumazet <eric.dumazet@gmail.com>
To: christoph.paasch@uclouvain.be
Cc: David Miller <davem@davemloft.net>, glommer@parallels.com,
        linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        gthelen@google.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        kirill@shutemov.name, avagin@parallels.com, devel@openvz.org,
        cgroups@vger.kernel.org
Date: Tue, 13 Dec 2011 14:59:08 +0100
In-Reply-To: <4EE757D7.6060006@uclouvain.be>
References: <1323676029-5890-1-git-send-email-glommer@parallels.com>
	 <20111212.190734.1967808916779299221.davem@davemloft.net>
	 <4EE757D7.6060006@uclouvain.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 décembre 2011 à 14:49 +0100, Christoph Paasch a écrit :

> now there are plenty of compiler-warnings when CONFIG_CGROUPS is not set:
> 
> In file included from include/linux/tcp.h:211:0,
>                  from include/linux/ipv6.h:221,
>                  from include/net/ip_vs.h:23,
>                  from kernel/sysctl_binary.c:6:
> include/net/sock.h:67:57: warning: ‘struct cgroup_subsys’ declared
> inside parameter list [enabled by default]
> include/net/sock.h:67:57: warning: its scope is only this definition or
> declaration, which is probably not what you want [enabled by default]
> include/net/sock.h:67:57: warning: ‘struct cgroup’ declared inside
> parameter list [enabled by default]
> include/net/sock.h:68:61: warning: ‘struct cgroup_subsys’ declared
> inside parameter list [enabled by default]
> include/net/sock.h:68:61: warning: ‘struct cgroup’ declared inside
> parameter list [enabled by default]
> 
> 
> Because struct cgroup is only declared if CONFIG_CGROUPS is enabled.
> (cfr. linux/cgroup.h)
> 

Yes, we probably need forward reference like this :

Thanks !

[PATCH net-next] net: fix build error if CONFIG_CGROUPS=n

Reported-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/net/sock.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 18ecc99..6fe0dae 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -64,6 +64,8 @@
 #include <net/dst.h>
 #include <net/checksum.h>
 
+struct cgroup;
+struct cgroup_subsys;
 int mem_cgroup_sockets_init(struct cgroup *cgrp, struct cgroup_subsys *ss);
 void mem_cgroup_sockets_destroy(struct cgroup *cgrp, struct cgroup_subsys *ss);
 /*


