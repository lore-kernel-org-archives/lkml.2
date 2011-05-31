Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1EaEc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 00:32:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56888 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1EaEc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 00:32:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE46F69.4000205@jp.fujitsu.com>
Date: Tue, 31 May 2011 13:32:41 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: caiqian@redhat.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH v2 0/5] Fix oom killer doesn't work at all if system have
 > gigabytes memory  (aka CAI founded issue)
References: <2135926037.315785.1306805582148.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4DE46A4B.40401@jp.fujitsu.com>
In-Reply-To: <4DE46A4B.40401@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/31 13:10), KOSAKI Motohiro wrote:
> (2011/05/31 10:33), CAI Qian wrote:
>> Hello,
>>
>> Have tested those patches rebased from KOSAKI for the latest mainline.
>> It still killed random processes and recevied a panic at the end by
>> using root user. The full oom output can be found here.
>> http://people.redhat.com/qcai/oom
> 
> You ran fork-bomb as root. Therefore unprivileged process was killed at first.
> It's no random. It's intentional and desirable. I mean
> 
> - If you run the same progream as non-root, python will be killed at first.
>   Because it consume a lot of memory than daemons.
> - If you run the same program as root, non root process and privilege explicit
>   dropping processes (e.g. irqbalance) will be killed at first.

I mean, oom-killer start to kill python after killing all unprivilege process
in this case. Please wait & see ahile after sequence.



