Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab0HWAWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 20:22:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56484 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0HWAWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 20:22:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causes hibernationto hang
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20100820115449.5FF1.A69D9226@jp.fujitsu.com>
References: <4C677A49.4030904@superonline.com> <20100820115449.5FF1.A69D9226@jp.fujitsu.com>
Message-Id: <20100823091948.6029.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 23 Aug 2010 09:22:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry, my last mail has some mistake.

> Hmm... 
> I've tested hibernation case for a while. but I have no luck. I couldn't
> reproduce your issue. Very sorry. Can you please help our debugging? 
> If possible, I hope to run following three test.
> 
> 1. Please let me know your machine & test script
> 

% ./your-fills-up-the-tmpfs-script   (i.e. run your script)

> % cat /proc/meminfo
> % cat /proc/vmstat
> % cat /proc/zoneinfo
> % df
> % cat your-fills-up-the-tmpfs-script
> 
> 2. call shrink_all_memory() forcely and show result
> 


% ./your-fills-up-the-tmpfs-script

> % cat /proc/meminfo
> % cat /proc/zoneinfo
> # echo 1 > /proc/sys/vm/shrink_all_memory
> # tail /var/log/messages
> % cat /proc/meminfo
> % cat /proc/zoneinfo
> 
> 
> 3. reset zone_reclaim_stat and rerun shrink_all_memory
> 


% ./your-fills-up-the-tmpfs-script

> # echo 1 > /proc/sys/vm/reset_reclaim_stat
> % cat /proc/meminfo
> % cat /proc/zoneinfo
> # echo 1 > /proc/sys/vm/shrink_all_memory
> # tail /var/log/messages
> % cat /proc/meminfo
> % cat /proc/zoneinfo
> 
> 



