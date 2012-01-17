Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2AQQgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:36:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab2AQQgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:36:17 -0500
Message-ID: <4F15A34F.40808@redhat.com>
Date: Tue, 17 Jan 2012 11:35:27 -0500
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
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <1326788038-29141-2-git-send-email-minchan@kernel.org> <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
In-Reply-To: <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 04:27 AM, Pekka Enberg wrote:
> On Tue, Jan 17, 2012 at 10:13 AM, Minchan Kim<minchan@kernel.org>  wrote:
>> +static unsigned int low_mem_notify_poll(struct file *file, poll_table *wait)
>> +{
>> +        unsigned int ret = 0;
>> +
>> +        poll_wait(file,&low_mem_wait, wait);
>> +
>> +        if (atomic_read(&nr_low_mem) != 0) {
>> +                ret = POLLIN;
>> +                atomic_set(&nr_low_mem, 0);
>> +        }
>> +
>> +        return ret;
>> +}
>
> Doesn't this mean that only one application will receive the notification?

One at a time, which could be a good thing since the last
thing we want to do when the system is under memory
pressure is create a thundering herd.

OTOH, we do need to ensure that programs take turns getting
the memory pressure notification.  I do not know whether
poll_wait automatically takes care of that...

-- 
All rights reversed
