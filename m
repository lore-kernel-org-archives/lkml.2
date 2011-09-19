Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1ISFvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 01:51:24 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62849 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1ISFvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 01:51:23 -0400
Message-ID: <4E76D810.6010504@ce.jp.nec.com>
Date: Mon, 19 Sep 2011 14:50:08 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Mike Snitzer <snitzer@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
References: <20110720082640.GZ7561@ics.muni.cz> <4E280964.6070000@ct.jp.nec.com> <20110721132627.GY7561@ics.muni.cz> <4E291F28.2040609@ct.jp.nec.com> <20110722081903.GB7561@ics.muni.cz> <4E2A7806.1060601@ce.jp.nec.com> <20110724221619.GM16487@ics.muni.cz> <4E367256.8020206@ct.jp.nec.com> <20110908132756.GT31717@ics.muni.cz> <CAMM=eLd9fToJ5Kh+vf4WG1ZN-qTc2CX98-+BUkFWWQQ=tCG7LQ@mail.gmail.com> <20110916140839.GE7428@ics.muni.cz>
In-Reply-To: <20110916140839.GE7428@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas,

On 09/16/11 23:08, Lukas Hejtmanek wrote:
> On Thu, Sep 15, 2011 at 02:49:52PM -0400, Mike Snitzer wrote:
>> Does "with your patch" mean against 3.0.3 or the original 2.6.32 kernel?
>>
>> If you apply the patch to the 3.0.3 kernel do you regain the performance?
> 
> Unfortunately, the patch does not help with 3.0.3 kernel

Thanks for the additional testing.

So:

  2.6.32.36
    no-multipath:        2.8 GB/s
    multipath:           600 MB/s
    multipath w/ patch:  2.8-2.9 GB/s

  3.0.3
    no-multipath:        ??
    multipath:           2.5 GB/s
    multipath w/ patch:  2.5 GB/s(?)

Have you tried 3.0.3 without multipath?

> top looks like this:
>    63 root      20   0     0    0    0 S   38  0.0   0:16.65 kswapd1
>    18 root      20   0     0    0    0 R   32  0.0   0:14.38 kworker/4:0
>    19 root      20   0     0    0    0 R   30  0.0   0:20.88 ksoftirqd/4
>   153 root      20   0     0    0    0 R   29  0.0   0:14.46 kworker/4:2
>    62 root      20   0     0    0    0 S   22  0.0   0:09.44 kswapd0

dm-multipath itself does not use workqueue for normal I/Os.
So you might be hitting a different problem.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
