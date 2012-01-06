Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab2AFGbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:31:33 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:54431 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751447Ab2AFGbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:31:32 -0500
Message-ID: <4F06951E.7050605@tao.ma>
Date: Fri, 06 Jan 2012 14:30:54 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: do not drain pagevecs for mlock
References: <1325226961-4271-1-git-send-email-tm@tao.ma> <CAHGf_=qOGy3MQgiFyfeG82+gbDXTBT5KQjgR7JqMfQ7e7RSGpA@mail.gmail.com> <4EFD7AE3.8020403@tao.ma> <CAHGf_=pODc6fLGJAEZWzQtUd6fj6v=fV9n6UTwysqRR1SwY++A@mail.gmail.com> <4EFD8832.6010905@tao.ma> <CAHGf_=qA3Pnb00n_smhJVKDDCDDr0d-a3E03Rrhnb-S4xK8_fQ@mail.gmail.com> <4F069120.8060300@tao.ma> <CAHGf_=qhKbVCeUe+y8Hmb=ke-f417K5EYFo=j4ZODVGwewgh6A@mail.gmail.com>
In-Reply-To: <CAHGf_=qhKbVCeUe+y8Hmb=ke-f417K5EYFo=j4ZODVGwewgh6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 02:18 PM, KOSAKI Motohiro wrote:
> 2012/1/6 Tao Ma <tm@tao.ma>:
>> Hi Kosaki,
>> On 12/30/2011 06:07 PM, KOSAKI Motohiro wrote:
>>>>> Because your test program is too artificial. 20sec/100000times =
>>>>> 200usec. And your
>>>>> program repeat mlock and munlock the exact same address. so, yes, if
>>>>> lru_add_drain_all() is removed, it become near no-op. but it's
>>>>> worthless comparision.
>>>>> none of any practical program does such strange mlock usage.
>>>> yes, I should say it is artificial. But mlock did cause the problem in
>>>> our product system and perf shows that the mlock uses the system time
>>>> much more than others. That's the reason we created this program to test
>>>> whether mlock really sucks. And we compared the result with
>>>> rhel5(2.6.18) which runs much much faster.
>>>>
>>>> And from the commit log you described, we can remove lru_add_drain_all
>>>> safely here, so why add it? At least removing it makes mlock much faster
>>>> compared to the vanilla kernel.
>>>
>>> If we remove it, we lose to a test way of mlock. "Memlocked" field of
>>> /proc/meminfo
>>> show inaccurate number very easily. So, if 200usec is no avoidable,
>>> I'll ack you.
>>> But I'm not convinced yet.
>> Do you find something new for this?
> 
> No.
> 
> Or more exactly, 200usec is my calculation mistake. your program call mlock
> 3 times per each iteration. so, correct cost is 66usec.
yes, so mlock can do 15000/s, it is even slower than the whole i/o time
for some not very fast ssd disk and I don't think it is endurable. I
guess we should remove it, right? Or you have another other suggestion
that I can try for it?

Thanks
Tao
