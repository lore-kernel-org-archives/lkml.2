Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab2EJJtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:49:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36525 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab2EJJtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:49:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FAB8EB5.8080901@jp.fujitsu.com>
Date: Thu, 10 May 2012 18:47:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andre Nathan <andre@digirati.com.br>
CC: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: About cgroup memory limits
References: <1336588657.26723.23.camel@andre>
In-Reply-To: <1336588657.26723.23.camel@andre>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/10 3:37), Andre Nathan wrote:

> Hello
> 
> I'm doing some tests with LXC and how it interacts with the memory
> cgroup limits, more specifically the memory.limit_in_bytes control file.
> 
> Am I correct in my understanding of the memory cgroup documentation[1]
> that the limit set in memory.limit_in_bytes is applied to the sum of the
> fields 'cache', 'rss' and 'mapped_file' in the memory.stat file?
> 

cache includes mapped_file. Then,

rss + cache < limit.

cache - mapped_file == unmapped file caches.


> I am also trying to understand the values reported in memory.stat when
> compared to the statistics in /proc/$PID/statm.
> 
> Below is the sum of each field in /proc/$PID/statm for every process
> running inside a test container, converted to bytes:
> 
>        size  resident     share     text  lib       data  dt
>   897208320  28741632  20500480  1171456    0  170676224   0
> 

from statm source code.

size      = total virtual memory size
            # total amount of mmaps().

shared    = mapped_file
            # resident mapped file caches

text      = end_code - start_code
            # end_code and start_code is determined when the program is loaded.
            # this is virtual memory size.

data      = total virtual memory size  - MAP_SHARED virtual memory size.

regisdent = anonymous pages + mapped_file.


> Compare this with the usage reports from memory.stat (fields total_*,
> hierarchical_* and pg* omitted):
> 
> cache                     16834560
> rss                       8192000
> mapped_file               3743744
> swap                      0
> inactive_anon             0
> active_anon               8192000
> inactive_file             13996032
> active_file               2838528
> unevictable               0
> 
> Is there a way to reconcile these numbers somehow? I understand that the
> fields from the two files represent different things. What I'm trying to
> do is to combine, for example, the fields from memory.stat to
> approximately reach what is displayed by statm.
> 


>From above, rss + mapped_file == resident.

Thanks,
-Kame


