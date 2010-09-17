Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0IQA0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 20:26:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37997 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0IQA0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 20:26:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFCv2][PATCH] add some drop_caches documentation and info messsge
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lnxninja@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com
In-Reply-To: <20100916165047.DAD42998@kernel.beaverton.ibm.com>
References: <20100916165047.DAD42998@kernel.beaverton.ibm.com>
Message-Id: <20100917092603.3BD5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 17 Sep 2010 09:26:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff -puN fs/drop_caches.c~update-drop_caches-documentation fs/drop_caches.c
> --- linux-2.6.git/fs/drop_caches.c~update-drop_caches-documentation	2010-09-16 09:43:52.000000000 -0700
> +++ linux-2.6.git-dave/fs/drop_caches.c	2010-09-16 09:43:52.000000000 -0700
> @@ -47,6 +47,8 @@ int drop_caches_sysctl_handler(ctl_table
>  {
>  	proc_dointvec_minmax(table, write, buffer, length, ppos);
>  	if (write) {
> +		printk(KERN_NOTICE "%s (%d): dropped kernel caches: %d\n",
> +			current->comm, task_pid_nr(current), sysctl_drop_caches);
>  		if (sysctl_drop_caches & 1)
>  			iterate_supers(drop_pagecache_sb, NULL);
>  		if (sysctl_drop_caches & 2)

Can't you print it only once?



