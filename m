Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2IRFtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:49:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:53769 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2IRFtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:49:21 -0400
Message-ID: <50580B51.70300@kernel.dk>
Date: Tue, 18 Sep 2012 07:49:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jianpeng Ma <majianpeng@gmail.com>
CC: tj <tj@kernel.org>, rostedt <rostedt@goodmis.org>,
        fweisbec <fweisbec@gmail.com>, mingo <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Tao Ma <boyu.mt@taobao.com>
Subject: Re: Why blktrace didn't trace requests merge?
References: <201209171933464847623@gmail.com> <1347888148.13080.20.camel@gandalf.local.home> <20120917175534.GG18677@google.com>,  <50576BAE.4020602@kernel.dk> <201209180830165936690@gmail.com>
In-Reply-To: <201209180830165936690@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-18 02:30, Jianpeng Ma wrote:
> On 2012-09-18 02:27 Jens Axboe <axboe@kernel.dk> Wrote:
>> On 2012-09-17 19:55, Tejun Heo wrote:
>>> (cc'ing Jens)
>>>
>>> On Mon, Sep 17, 2012 at 09:22:28AM -0400, Steven Rostedt wrote:
>>>> On Mon, 2012-09-17 at 19:33 +0800, Jianpeng Ma wrote:
>>>>> Hi all:
>>>>> 	I used blktrace to trace some io.But i can't find requests merge. I searched the code and did't not find.
>>>>> 	Why? 
>>>>> 									
>>>>
>>>> No idea. I don't use blktrace much, but I Cc'd those that understand it
>>>> better than I.
>>
>> Works for me:
>>
>> [...]
>>
>>
>>  8,0    0       26     0.009147735   664  A  WS 315226143 + 8 <- (8,7) 19406344
>>  8,0    0       27     0.009148677   664  Q  WS 315226143 + 8 [btrfs-submit-1]
>>  8,0    0       28     0.009152967   664  G  WS 315226143 + 8 [btrfs-submit-1]
>>  8,0    0       29     0.009154242   664  P   N [btrfs-submit-1]
>>  8,0    0       30     0.009155538   664  A  WS 315226151 + 8 <- (8,7) 19406352
>>  8,0    0       31     0.009155743   664  Q  WS 315226151 + 8 [btrfs-submit-1]
>>  8,0    0       32     0.009157086   664  M  WS 315226151 + 8 [btrfs-submit-1]
>>  8,0    0       33     0.009158716   664  I  WS 315226143 + 16 [btrfs-submit-1]
>>
>> That's from a quick trace of /dev/sda. I started blktrace, then did:
>>
>> $ dd if=/dev/zero of=foo bs=4k count=128 && sync
>>
>> to ensure that I knew merges would be happening. Output stats at the end:
>>
>> Total (sda):
>> Reads Queued:           7,       44KiB  Writes Queued:         447,     7692KiB
>> Read Dispatches:        7,       44KiB  Write Dispatches:      416,     7692KiB
>> Reads Requeued:         0               Writes Requeued:         0
>> Reads Completed:        7,       44KiB  Writes Completed:      435,     5864KiB
>> Read Merges:            0,        0KiB  Write Merges:           23,      428KiB
>> IO unplugs:            78               Timer unplugs:           0
>>
>> -- 
>> Jens Axboe
>>
> First, Thanks your time!
> If i understand correctly, the merge of your example is bio with
> request, not request wiht request.  Yes or no?

It is bio to request, correct. Request to request merges are relatively
more rare.

-- 
Jens Axboe

