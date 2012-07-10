Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2GJLF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:05:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51184 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2GJLFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:05:55 -0400
Subject: Re: [PATCH v2] net: cgroup: fix access the unallocated memory in
 netprio cgroup
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        Eric Dumazet <edumazet@google.com>
In-Reply-To: <1341917043-13264-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1341917043-13264-1-git-send-email-gaofeng@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jul 2012 13:05:50 +0200
Message-ID: <1341918350.3265.4830.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 18:44 +0800, Gao feng wrote:
> there are some out of bound accesses in netprio cgroup.

> -	update_netdev_tables();
> +	ret = extend_netdev_table(dev, max_len);
> +	if (ret < 0)
> +		goto out_free_devname;
> +
>  	ret = 0;
>  	rcu_read_lock();
>  	map = rcu_dereference(dev->priomap);

Its unfortunately adding a bug.

extend_netdev_table() is protected by RTNL.



