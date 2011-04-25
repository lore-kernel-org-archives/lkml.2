Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab1DYHrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 03:47:31 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48348 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab1DYHra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 03:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Mz6HOvvlW+1My40SciVaVz3ZzrNtQdTS6otKd/rTx288rQ82wNyeLoQbPgDgcQaS4r
         QVm1GkPwAycwYW+IzcB9Ns4hmDS8+2syUYj5zCTfGcERiIUSV7eXcMUurSuOcdeAEE2Y
         QMf0jIHvP0vfypwWt11izMOqfWuj8pNYGTPUI=
MIME-Version: 1.0
In-Reply-To: <20110425114429.266A.A69D9226@jp.fujitsu.com>
References: <20110424202158.45578f31@neptune.home> <20110424235928.71af51e0@neptune.home>
 <20110425114429.266A.A69D9226@jp.fujitsu.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 25 Apr 2011 03:47:09 -0400
Message-ID: <BANLkTinVQtLbmBknBZeY=7w7AOyQk61Pew@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 22:42, KOSAKI Motohiro wrote:
>> On Sun, 24 April 2011 Bruno Prémont wrote:
>> > On an older system I've been running Gentoo's revdep-rebuild to check
>> > for system linking/*.la consistency and after doing most of the work the
>> > system starved more or less, just complaining about stuck tasks now and
>> > then.
>> > Memory usage graph as seen from userspace showed sudden quick increase of
>> > memory usage though only a very few MB were swapped out (c.f. attached RRD
>> > graph).
>>
>> Seems I've hit it once again (though detected before system was fully
>> stalled by trying to reclaim memory without success).
>>
>> This time it was during simple compiling...
>> Gathered info below:
>>
>> /proc/meminfo:
>> MemTotal:         480660 kB
>> MemFree:           64948 kB
>> Buffers:           10304 kB
>> Cached:             6924 kB
>> SwapCached:         4220 kB
>> Active:            11100 kB
>> Inactive:          15732 kB
>> Active(anon):       4732 kB
>> Inactive(anon):     4876 kB
>> Active(file):       6368 kB
>> Inactive(file):    10856 kB
>> Unevictable:          32 kB
>> Mlocked:              32 kB
>> SwapTotal:        524284 kB
>> SwapFree:         456432 kB
>> Dirty:                80 kB
>> Writeback:             0 kB
>> AnonPages:          6268 kB
>> Mapped:             2604 kB
>> Shmem:                 4 kB
>> Slab:             250632 kB
>> SReclaimable:      51144 kB
>> SUnreclaim:       199488 kB   <--- look big as well...
>> KernelStack:      131032 kB   <--- what???
>
> KernelStack is used 8K bytes per thread. then, your system should have
> 16000 threads. but your ps only showed about 80 processes.
> Hmm... stack leak?

i might have a similar report for 2.6.39-rc4 (seems to be working fine
in 2.6.38.4), but for embedded Blackfin systems running gdbserver
processes over and over (so lots of short lived forks)

i wonder if you have a lot of zombies or otherwise unclaimed resources
?  does `ps aux` show anything unusual ?
-mike
