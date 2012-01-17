Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2AQTbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:31:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab2AQTbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:31:13 -0500
Message-ID: <4F15CC56.90309@redhat.com>
Date: Tue, 17 Jan 2012 14:30:30 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Minchan Kim <minchan@kernel.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <1326788038-29141-2-git-send-email-minchan@kernel.org> <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com> <4F15A34F.40808@redhat.com> <alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 01:51 PM, Pekka Enberg wrote:
> Hello,
>
> Ok, so here's a proof of concept patch that implements sample-base
> per-process free threshold VM event watching using perf-like syscall
> ABI. I'd really like to see something like this that's much more
> extensible and clean than the /dev based ABIs that people have proposed
> so far.

Looks like a nice extensible interface to me.

The only thing is, I expect we will not want to wake
up processes most of the time, when there is no memory
pressure, because that would just waste battery power
and/or cpu time that could be used for something else.

The desire to avoid such wakeups makes it harder to
wake up processes at arbitrary points set by the API.

Another issue is that we might be running two programs
on the system, each with a different threshold for
"lets free some of my cache".  Say one program sets
the threshold at 20% free/cache memory, the other
program at 10%.

We could end up with the first process continually
throwing away its caches, while the second process
never gives its unused memory back to the kernel.

I am not sure what the right thing to do would be...

-- 
All rights reversed
