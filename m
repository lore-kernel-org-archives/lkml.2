Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2LZGtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 01:49:39 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:59841 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2LZGth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 01:49:37 -0500
Message-ID: <50DA9DB8.6080506@huawei.com>
Date: Wed, 26 Dec 2012 14:48:24 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Neil Horman <nhorman@tuxdriver.com>, LKML <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] netprio_cgroup: define sk_cgrp_prioidx only if NETPRIO_CGROUP
 is enabled
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sock->sk_cgrp_prioidx won't be used at all if CONFIG_NETPRIO_CGROUP=n.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 93a6745..182ca99 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -367,7 +367,7 @@ struct sock {
 	unsigned short		sk_ack_backlog;
 	unsigned short		sk_max_ack_backlog;
 	__u32			sk_priority;
-#ifdef CONFIG_CGROUPS
+#if IS_ENABLED(CONFIG_NETPRIO_CGROUP)
 	__u32			sk_cgrp_prioidx;
 #endif
 	struct pid		*sk_peer_pid;
-- 
1.8.0.2

