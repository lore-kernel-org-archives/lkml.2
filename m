Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab0DJMJK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 08:09:10 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34395 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab0DJMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 08:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OsdLgL6Uq/9jYcYazihQ78KQyIJfemGEvrdz7E0gjmJ+Hym5i/WIA1DznTO5xRhRxu
         T28TvNA4wAPpZHVjsjmghHR9UMQp0pq1v42RV+1ze50QE50DKdvFzsAvtcE87/nVTpcp
         VptEEu8CmW1UgbRVdm598wAYefIlKWNsxV3/w=
Message-ID: <4BC06A5F.6070804@gmail.com>
Date: Sat, 10 Apr 2010 14:09:03 +0200
From: Cristian KLEIN <cristiklein@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100404 Lightning/1.0pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp: add setsockopt to disable slow start after idle
References: <1270863015-19597-1-git-send-email-cristiklein@gmail.com> <20100409.221307.246951787.davem@davemloft.net>
In-Reply-To: <20100409.221307.246951787.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 07:13, David Miller wrote:
> From: Cristian KLEIN<cristiklein@gmail.com>
> Date: Sat, 10 Apr 2010 03:30:15 +0200
>
>> Allows user-space to override the sysctl
>> net.ipv4.tcp_slow_start_after_idle, on a per-socket bases, using
>> setsockopt().
>>
>> Slow start after idle can harm some scientific applications which
>> interleave computation and communication. Assume we have an iterative
>> applications, each iteration consisting of a computation and a
>> communication phase. If the computation phase takes long enough (i.e.
>> more that 2*RTT), the communication phase will always slow start and
>> might never reach the wire speed.
>>
>> This patch allows each application to disable slow start after idle,
>> just like we allow delay-sensitive applications (e.g. telnet, SSH) to
>> disable NAGLE.
>>
>> Signed-off-by: Cristian KLEIN<cristiklein@gmail.com>
>
> We specifically did not add a socket option for this facility.
>
> It is a very dangerous option to enable, and depends deeply
> upon the characteristics of your network and the paths by
> which remote hosts are reached.
>
> Therefore, only the system administrator can determine whether it is
> safe to enable this, and that's why it can only be changed via sysctl.
> Lettting arbitrary applications change this aspect of TCP is beyond
> dangerous.
>
> I will not be applying this patch.

Could you please explain me why it is dangerous? To me it seems that 
it's just like allowing applications to disable NAGLE or to choose a 
congestion control algorithm.
