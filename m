Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab1HZDa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 23:30:58 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62152 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1HZDa5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 23:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110826032601.GA26282@localhost>
References: <4E5494D4.1050605@profihost.ag> <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com>
 <4E54BDCF.9020504@profihost.ag> <20110824093336.GB5214@localhost>
 <4E560F2A.1030801@profihost.ag> <20110826021648.GA19529@localhost>
 <4E570AEB.1040703@profihost.ag> <20110826030313.GA24058@localhost>
 <D299D0AE-2F3C-42E2-9723-A3D7C0108C40@profihost.ag> <20110826032601.GA26282@localhost>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Fri, 26 Aug 2011 11:30:35 +0800
Message-ID: <CAC8teKXqZktBK7+GbLgHn-2k+zjjf8uieRM_q_V7JK7ePAk9Lg@mail.gmail.com>
Subject: Re: slow performance on disk/network i/o full speed after drop_caches
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Stefan Priebe <s.priebe@profihost.ag>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang,
Maybe it's because zone_reclaim_mode? We often have received some reports that
scp or something like that is slow with no reason, and mostly it's due
to someone
enabled zone_reclaim_mode by mistake.

Stefan, is your zone_reclaim_mode enabled? try 'cat
/proc/sys/vm/zone_reclaim_mode',
and echo 0 to it to disable.

Thanks,
Zhu Yanhai

2011/8/26 Wu Fengguang <fengguang.wu@intel.com>:
> On Fri, Aug 26, 2011 at 11:13:07AM +0800, Stefan Priebe wrote:
>>
>> >> There is at least a numastat proc file.
>> >
>> > Thanks. This shows that node0 is accessed 10x more than node1.
>>
>> What can i do to prevent this or isn't this normal when a machine mostly idles so processes are mostly processed by cpu0.
>
> Yes, that's normal. However it should explain why it's slow even when
> there are lots of free pages _globally_.
>
>> >
>> >> complete ps output:
>> >> http://pastebin.com/raw.php?i=b948svzN
>> >
>> > In that log, scp happens to be in R state and also no other tasks in D
>> > state. Would you retry in the hope of catching some stucked state?
>> Sadly not as the sysrq trigger has rebootet the machine and it will now run fine for 1 or 2 days.
>
> Oops, sorry! It might be possible to reproduce the issue by manually
> eating all of the memory with sparse file data:
>
>        truncate -s 1T 1T
>        cp 1T /dev/null
>
>> >
>> >>>         echo t>  /proc/sysrq-trigger
>> >> sadly i wa sonly able to grab the output in this crazy format:
>> >> http://pastebin.com/raw.php?i=MBXvvyH1
>> >
>> > It's pretty readable dmesg, except that the data is incomplete and
>> > there are nothing valuable in the uploaded portion..
>> That was everything i could grab through netconsole. Is there a better way?
>
> netconsole is enough.  The partial output should be due to the reboot...
>
> Thanks,
> Fengguang
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
