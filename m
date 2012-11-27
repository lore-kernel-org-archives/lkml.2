Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab2K0HkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:40:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47475 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2K0HkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:40:14 -0500
Message-ID: <50B46E05.70906@kernel.dk>
Date: Tue, 27 Nov 2012 08:38:45 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Mikulas Patocka <mpatocka@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Recent kernel "mount" slow
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com> <20121120180949.GG1408@quack.suse.cz> <CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com> <CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com> <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com> <50AF7901.20401@kernel.dk> <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com> <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com> <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com> <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
In-Reply-To: <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-27 06:57, Jeff Chua wrote:
> On Sun, Nov 25, 2012 at 7:23 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> On Sun, Nov 25, 2012 at 5:09 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>> So it's better to slow down mount.
>>
>> I am quite proud of the linux boot time pitting against other OS. Even
>> with 10 partitions. Linux can boot up in just a few seconds, but now
>> you're saying that we need to do this semaphore check at boot up. By
>> doing so, it's inducing additional 4 seconds during boot up.
> 
> By the way, I'm using a pretty fast SSD (Samsung PM830) and fast CPU
> (2.8GHz). I wonder if those on slower hard disk or slower CPU, what
> kind of degradation would this cause or just the same?

It'd likely be the same slow down time wise, but as a percentage it
would appear smaller on a slower disk.

Could you please test Mikulas' suggestion of changing
synchronize_sched() in include/linux/percpu-rwsem.h to
synchronize_sched_expedited()?

linux-next also has a re-write of the per-cpu rw sems, out of Andrews
tree. It would be a good data point it you could test that, too.

In any case, the slow down definitely isn't acceptable. Fixing an
obscure issue like block sizes changing while O_DIRECT is in flight
definitely does NOT warrant a mount slow down.

-- 
Jens Axboe

