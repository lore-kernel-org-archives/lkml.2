Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2A3DRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:17:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51487 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab2A3DRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:17:39 -0500
MIME-Version: 1.0
In-Reply-To: <20120129161058.GA13156@localhost>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
	<20120128125108.GA9661@localhost>
	<1327757611.7199.6.camel@edumazet-laptop>
	<20120129055917.GB8513@localhost>
	<1327831380.14602.6.camel@edumazet-laptop>
	<20120129111645.GA5839@localhost>
	<1327842831.2718.2.camel@edumazet-laptop>
	<20120129161058.GA13156@localhost>
Date: Mon, 30 Jan 2012 11:17:38 +0800
X-Google-Sender-Auth: q8VAMDaYFCY9XZbVk1a7xlFaS8s
Message-ID: <CANejiEW86b7btiOcVFF3qVhqU1t6FRosvgfiydWwU5zgeDFOqw@mail.gmail.com>
Subject: Re: Bad SSD performance with recent kernels
From: Shaohua Li <shaohua.li@intel.com>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/30 Wu Fengguang <wfg@linux.intel.com>:
> On Sun, Jan 29, 2012 at 02:13:51PM +0100, Eric Dumazet wrote:
>> Le dimanche 29 janvier 2012 à 19:16 +0800, Wu Fengguang a écrit :
>>
>>
>> > Note that as long as buffered read(2) is used, it makes almost no
>> > difference (well, at least for now) to do "dd bs=128k" or "dd bs=2MB":
>> > the 128kb readahead size will be used underneath to submit read IO.
>> >
>>
>> Hmm...
>>
>> # echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=128k count=32768
>> 32768+0 enregistrements lus
>> 32768+0 enregistrements écrits
>> 4294967296 octets (4,3 GB) copiés, 20,7718 s, 207 MB/s
>>
>>
>> # echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=2M count=2048
>> 2048+0 enregistrements lus
>> 2048+0 enregistrements écrits
>> 4294967296 octets (4,3 GB) copiés, 27,7824 s, 155 MB/s
>
> Interesting. Here are my test results:
>
> root@lkp-nex04 /home/wfg# echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=128k count=32768
> 32768+0 records in
> 32768+0 records out
> 4294967296 bytes (4.3 GB) copied, 19.0121 s, 226 MB/s
> root@lkp-nex04 /home/wfg# echo 3 >/proc/sys/vm/drop_caches ;dd if=/dev/sda of=/dev/null bs=2M count=2048
> 2048+0 records in
> 2048+0 records out
> 4294967296 bytes (4.3 GB) copied, 19.0214 s, 226 MB/s
>
> Maybe the /dev/sda performance bug on your machine is sensitive to timing?
I got similar result:
128k: 224M/s
1M: 182M/s

1M block size is slow, I guess it's CPU related.

And as for the big regression with newer kernel than 2.6.38, please
check if idle=poll
helps. CPU idle dramatically impacts disk performance and even latest
cpuidle governor
doesn't help for some CPUs.

Thanks,
Shaohua
