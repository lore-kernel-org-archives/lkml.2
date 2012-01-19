Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2ASJK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:10:27 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41336 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046Ab2ASJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:10:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F17DCED.4020908@redhat.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
	<CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
	<4F15A34F.40808@redhat.com>
	<alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
	<84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com>
	<CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
	<84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com>
	<CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
	<84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
	<4F175706.8000808@redhat.com>
	<alpine.LFD.2.02.1201190922390.3033@tux.localdomain>
	<4F17DCED.4020908@redhat.com>
Date: Thu, 19 Jan 2012 11:10:20 +0200
X-Google-Sender-Auth: IhnqItYe_yt8rsHfDMu3tgTYesU
Message-ID: <CAOJsxLG3x_R5xq85hh5RvPoD+nhgYbHJfbLW=YMxCZockAXJqw@mail.gmail.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
From: Pekka Enberg <penberg@kernel.org>
To: Ronen Hod <rhod@redhat.com>
Cc: leonid.moiseichuk@nokia.com, riel@redhat.com, minchan@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        kosaki.motohiro@gmail.com, hannes@cmpxchg.org, mtosatti@redhat.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 11:05 AM, Ronen Hod <rhod@redhat.com> wrote:
>>> I believe that it will be best if the kernel publishes an ideal
>>> number_of_free_pages (in /proc/meminfo or whatever). Such number is easy to
>>> work with since this is what applications do, they free pages. Applications
>>> will be able to refer to this number from their garbage collector, or before
>>> allocating memory also if they did not get a notification, and it is also
>>> useful if several applications free memory at the same time.
>>
>> Isn't
>>
>> /proc/sys/vm/min_free_kbytes
>>
>> pretty much just that?
>
> Would you suggest to use min_free_kbytes as the threshold for sending
> low_memory_notifications to applications, and separately as a target value
> for the applications' memory giveaway?

I'm not saying that the kernel should use it directly but it seems
like the kind of "ideal number of free pages" threshold you're
suggesting. So userspace can read that value and use it as the "number
of free pages" threshold for VM events, no?

                        Pekka
