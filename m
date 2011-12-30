Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1L3KIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 05:08:21 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64741 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1L3KIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 05:08:18 -0500
MIME-Version: 1.0
In-Reply-To: <4EFD8832.6010905@tao.ma>
References: <1325226961-4271-1-git-send-email-tm@tao.ma> <CAHGf_=qOGy3MQgiFyfeG82+gbDXTBT5KQjgR7JqMfQ7e7RSGpA@mail.gmail.com>
 <4EFD7AE3.8020403@tao.ma> <CAHGf_=pODc6fLGJAEZWzQtUd6fj6v=fV9n6UTwysqRR1SwY++A@mail.gmail.com>
 <4EFD8832.6010905@tao.ma>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 30 Dec 2011 05:07:57 -0500
X-Google-Sender-Auth: VaVygSfihyWIKnO80MkFBT5FPV0
Message-ID: <CAHGf_=qA3Pnb00n_smhJVKDDCDDr0d-a3E03Rrhnb-S4xK8_fQ@mail.gmail.com>
Subject: Re: [PATCH] mm: do not drain pagevecs for mlock
To: Tao Ma <tm@tao.ma>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Because your test program is too artificial. 20sec/100000times =
>> 200usec. And your
>> program repeat mlock and munlock the exact same address. so, yes, if
>> lru_add_drain_all() is removed, it become near no-op. but it's
>> worthless comparision.
>> none of any practical program does such strange mlock usage.
> yes, I should say it is artificial. But mlock did cause the problem in
> our product system and perf shows that the mlock uses the system time
> much more than others. That's the reason we created this program to test
> whether mlock really sucks. And we compared the result with
> rhel5(2.6.18) which runs much much faster.
>
> And from the commit log you described, we can remove lru_add_drain_all
> safely here, so why add it? At least removing it makes mlock much faster
> compared to the vanilla kernel.

If we remove it, we lose to a test way of mlock. "Memlocked" field of
/proc/meminfo
show inaccurate number very easily. So, if 200usec is no avoidable,
I'll ack you.
But I'm not convinced yet.
