Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2ARXfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:35:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab2ARXfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:35:18 -0500
Message-ID: <4F175706.8000808@redhat.com>
Date: Thu, 19 Jan 2012 01:34:30 +0200
From: Ronen Hod <rhod@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: leonid.moiseichuk@nokia.com
CC: penberg@kernel.org, riel@redhat.com, minchan@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        kosaki.motohiro@gmail.com, hannes@cmpxchg.org, mtosatti@redhat.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC 1/3] /dev/low_mem_notify
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <1326788038-29141-2-git-send-email-minchan@kernel.org> <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com> <4F15A34F.40808@redhat.com> <alpine.LFD.2.02.1201172044310.15303@tux.localdomain> <84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com> <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com> <84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com> <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com> <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
In-Reply-To: <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 12:44 PM, leonid.moiseichuk@nokia.com wrote:
>> -----Original Message-----
>> From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of ext
>> Pekka Enberg
>> Sent: 18 January, 2012 12:40
> ...
>>> Not worse than %%. For example you had 10% free memory threshold for
>>> 512 MB RAM meaning 51.2 MB in absolute number.  Then hotplug turned
>>> off 256 MB, you for sure must update threshold for %% because these
>>> 10% for 25.6 MB most likely will be not suitable for different operating
>> mode.
>>> Using pages makes calculations must simpler.
>> Right. Does threshold in percentages make any sense then? Is it enough to
>> use number of free pages?
> Paul Mundt noticed that and we stopped use percentage in 2006 for n770 update.
> He was right.
> Percents are useless and do not correlate with other kernel APIs like sysinfo().

I believe that it will be best if the kernel publishes an ideal number_of_free_pages (in /proc/meminfo or whatever). Such number is easy to work with since this is what applications do, they free pages. Applications will be able to refer to this number from their garbage collector, or before allocating memory also if they did not get a notification, and it is also useful if several applications free memory at the same time.

Ronen.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

