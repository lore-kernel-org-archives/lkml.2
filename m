Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab2BVS5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:57:33 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:50577 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2BVS5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:57:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of cyfmxc@gmail.com designates 10.229.135.10 as permitted sender) smtp.mail=cyfmxc@gmail.com; dkim=pass header.i=cyfmxc@gmail.com
MIME-Version: 1.0
X-Google-Sender-Delegation: tabloid.adroit@gmail.com
In-Reply-To: <4F4484AC.9050500@lge.com>
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com>
	<4F4484AC.9050500@lge.com>
Date: Wed, 22 Feb 2012 13:57:29 -0500
X-Google-Sender-Auth: vCGUhTu3tiCRREUnbWD8fHMbWrM
Message-ID: <CAJh9x3psvYArTQOBQa-TVBsW16qRTPJp+0L8hYJQTK7EJYy1tQ@mail.gmail.com>
Subject: Re: perf record: can I specify multiple events and use different
 sample-after value
From: Yuanfang Chen <cyfmxc@gmail.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 1:01 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> 2012-02-22 10:59 AM, Yuanfang Chen wrote:
>>
>> Hi all,
>>
>
> Hi,
>
>
>
>> I'm trying use perf tool from the linux kernel package to measure
>> several raw PMU events. In the manpage of perf-record there is an "-l"
>> option (Scale counter values), which is useful for my case because I
>> want to know the total counter value, not just sample count. However
>> it seems the -l is not recognized, is this expected? How can I get a
>> total count?
>>
>
> "perf report --show-total-period" will be your friend.
>
> BTW, it seems you were using old version of perf (and kernel too, maybe).
> I have no idea if your perf wouldn't support the option. :)

You are right. my perf version is 3.0.0, just updated to 3.3.0-rc4.
--show-total-period works now.

>
> The "-l" option was meaningful only if you specified events more than the
> actual number of counters in the PMU.

So -l is for multiplexing?

>
>
>
>> Another question is that how can I specify multiple events and use
>> different sample-after value for each of them? like perf record -c
>> 10000,2000000,2000000 -e r2d4,r03c,r0c0
>>
>
> It's not possible now. You should run a number of instances of perf for
> that purpose AFAIK.
>
>
> Thanks,
> Namhyung
