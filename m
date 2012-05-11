Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2EKAcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:32:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35192 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2EKAcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:32:20 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FAC5DA9.90202@jp.fujitsu.com>
Date: Fri, 11 May 2012 09:30:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andre Nathan <andre@digirati.com.br>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: About cgroup memory limits
References: <1336588657.26723.23.camel@andre>  <4FAB8EB5.8080901@jp.fujitsu.com> <1336647342.7710.5.camel@andre>
In-Reply-To: <1336647342.7710.5.camel@andre>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/10 19:55), Andre Nathan wrote:

> Thanks a lot Kame.
> 
> On Thu, 2012-05-10 at 18:47 +0900, KAMEZAWA Hiroyuki wrote:
>> From above, rss + mapped_file == resident.
> 
> But if you check the numbers I get from memory.stat and the sum of the
> statm fields for all container processes, this doesn't hold.
> 
> resident    = 28741632
> rss         = 8192000
> mapped_file = 3743744
> 
> Am I missing something here?
> 

Considering again...

file_mapped is accounted into the memcg where it's accounted as 'cache' to.

So, you can know 'mapped_file/caches ratio' but you can't know which cgroup
maps it.

>        size  resident     share     text  lib       data  dt
>   897208320  28741632  20500480  1171456    0  170676224   0
> 
 
resident - share = anon.

28741632  - 20500480 = 8241152 (anon)  near value to rss.

About file_mapped, 3743744(mapped_file)  * 100 /20500480(shared) = 18 %

18% of your app's file-mapping may be accounted into the memcg.

You may be able to different score if you do all test after drop-cache.
echo 3 > /proc/sys/vm/drop_caches

Thanks,
-Kame




