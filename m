Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2BGAbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:31:24 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47712 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab2BGAbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:31:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120206203604.GC21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
	<20120206151219.GC30752@redhat.com>
	<4F2FFB21.9000202@kernel.dk>
	<20120206163721.GF30752@redhat.com>
	<20120206164428.GA21292@google.com>
	<CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
	<20120206172706.GB21292@google.com>
	<20120206203604.GC21292@google.com>
Date: Tue, 7 Feb 2012 08:31:22 +0800
X-Google-Sender-Auth: HzjV51BtT1IdXoD42PXJlk5QTws
Message-ID: <CANejiEVzs=pUhQSTvUppkDcc2TNZyfohBRLygW5zFmXyk5A-xQ@mail.gmail.com>
Subject: Re: [patch]block: fix ioc locking warning
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/7 Tejun Heo <tj@kernel.org>:
> On Mon, Feb 06, 2012 at 09:27:06AM -0800, Tejun Heo wrote:
>> It's one wq scheduling on exit for any task which has issued an IO.  I
>> don't think it would matter except for task fork/exit microbenchs (or
>> workloads which approximate to that).  I'll get some measurements and
>> strip the optimization if it doesn't really show up.
>
> I'm still playing with test methods and getting numbers but the
> following is the simplified one of the three setups I'm playing with -
> the current one, simplified and no optimization.  There *seems* to be
> appreciable performance degradation on fork/exit w/ ioc microbenchs so
> I'm likely to go with the following.  I'll post when I know more.
Hi,
Since you are talking about performance, one of our microbenchmark (swap)
shows a regression. Alex bisect it to be b2efa05265d62bc2, which is related to
the ioc change. A little strange to me, don't expect such change can cause
performance issue. I haven't double check the issue, but if you have
ideas, please
let me know.

Thanks,
Shaohua
