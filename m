Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab1EaH5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:57:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53139 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab1EaH5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:57:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE49F44.10809@jp.fujitsu.com>
Date: Tue, 31 May 2011 16:56:52 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: caiqian@redhat.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH v2 0/5] Fix oom killer doesn't work at all if system have
 > gigabytes memory  (aka CAI founded issue)
References: <1685840459.318633.1306828245496.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1685840459.318633.1306828245496.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/31 16:50), CAI Qian wrote:
> 
> 
> ----- Original Message -----
>>>> - If you run the same program as root, non root process and
>>>> privilege
>>>> explicit
>>>> dropping processes (e.g. irqbalance) will be killed at first.
>>> Hmm, at least there were some programs were root processes but were
>>> killed
>>> first.
>>> [ pid] ppid uid total_vm rss swap score_adj name
>>> [ 5720] 5353 0 24421 257 0 0 sshd
>>> [ 5353] 1 0 15998 189 0 0 sshd
>>> [ 5451] 1 0 19648 235 0 0 master
>>> [ 1626] 1 0 2287 129 0 0 dhclient
>>
>> Hi
>>
>> I can't reproduce this too. Are you sure these processes have a full
>> root privilege?
>> I've made new debugging patch. After applying following patch, do
>> these processes show
>> cap=1?
> No, all of them had cap=0. Wondering why something like sshd not been
> made cap=1 to avoid early oom kill.

Then, I believe your distro applying distro specific patch to ssh.
Which distro are you using now?



