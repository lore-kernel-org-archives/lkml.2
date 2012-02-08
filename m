Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2BHATi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:19:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41521 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab2BHATh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:19:37 -0500
MIME-Version: 1.0
In-Reply-To: <20120207164735.GH21292@google.com>
References: <20120206163721.GF30752@redhat.com>
	<20120206164428.GA21292@google.com>
	<CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
	<20120206172706.GB21292@google.com>
	<4F303506.9000201@kernel.dk>
	<20120206215451.GD21292@google.com>
	<4F30C96F.1000905@kernel.dk>
	<20120207162253.GG21292@google.com>
	<4F315113.5010804@kernel.dk>
	<CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
	<20120207164735.GH21292@google.com>
Date: Wed, 8 Feb 2012 08:19:36 +0800
X-Google-Sender-Auth: YYLEjvBBEnyspkUHI1ldAr3Br-4
Message-ID: <CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/8 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Tue, Feb 07, 2012 at 08:33:15AM -0800, Linus Torvalds wrote:
>> Yeah, please just get rid of the crazy code. Maybe *that* fixes the
>> regression too, who knows?
>>
>> For all we know, the "fast case" is what causes extra locking only to
>> then fail and not even be a fast-path.
>
> Yeah, I was about to ask Shaohua to test the version w/o optimization.
> With heavily loaded request_queue, trylock failure could be frequent,
> which I wasn't testing.
>
> Shaohua, can you please test the version w/o optimization?  Also, can
> you please give a bit more details on the setup?  Are there multiple
> swap devices?  Is it SSD or rotating disk?
the test adds mem=4G in a 2 sockets 16 CPU machine.
just make several copy of kernel source in tmpfs (so there is swap
depending on your
memory size) and run kernel build in the kernel source in the meaning time.
there is only one swap device which is a rotating disk.

I'll test both patches soon.

Thanks,
Shaohua
