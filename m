Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2BOTjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:39:52 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab2BOTjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:39:51 -0500
Message-ID: <4F3C09FC.2020800@nod.at>
Date: Wed, 15 Feb 2012 20:39:40 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, pablo@netfilter.org, basti@b-bl.de
Subject: Re: [PATCH 2/2] Netfilter: xt_LOG: Add timestamp support
References: <1329314115-6899-1-git-send-email-richard@nod.at>  <1329314115-6899-2-git-send-email-richard@nod.at> <1329314492.2437.32.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4F3BBC11.1030308@nod.at> <alpine.LNX.2.01.1202151815270.15357@frira.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1202151815270.15357@frira.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.02.2012 18:16, schrieb Jan Engelhardt:
>
> On Wednesday 2012-02-15 15:07, Richard Weinberger wrote:
>>>> +		struct timespec tv;
>>>> +		unsigned int msec;
>>>> +
>>>> +		getnstimeofday(&tv);
>>>> +		msec = tv.tv_nsec / NSEC_PER_MSEC;
>>>> +		sb_add(m, "TIMESTAMP=%li.%03li ", tv.tv_sec, msec);
>>>
>>> Since you want to use this temp variable "unsigned int msec" (I have no
>>> idea why...), you must change printf format accordingly : %03u instead
>>> of %03li
>>
>> *grml*.
>> I'll remove the temp variable and use %03u.
>
> Why not just print the nsecs directly (with %09 of course)?

I don't think that a nanosecond resolution is useful.

Thanks,
//richard
