Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1AaT2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:28:35 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:42197 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1AaT2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:28:34 -0500
X-ASG-Debug-ID: 1296501852-01de290b791eb140005-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D470CA7.7020508@fusionio.com>
Date: Mon, 31 Jan 2011 20:25:27 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blkio-throttle: Avoid calling blkiocg_lookup_group()
 for root group
References: <20110117215606.GI5624@redhat.com>	<20110126185729.GD6713@redhat.com> <x49ei7sq3qe.fsf@segfault.boston.devel.redhat.com> <4D470C50.6010701@kernel.dk>
X-ASG-Orig-Subj: Re: [PATCH] blkio-throttle: Avoid calling blkiocg_lookup_group()
 for root group
In-Reply-To: <4D470C50.6010701@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1296502005
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4971 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.53996
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-31 20:24, Jens Axboe wrote:
> On 2011-01-31 20:20, Jeff Moyer wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>>
>>> On Mon, Jan 17, 2011 at 04:56:06PM -0500, Vivek Goyal wrote:
>>>> o Jeff Moyer was doing some testing on a RAM backed disk and
>>>>   blkiocg_lookup_group() showed up high overhead after memcpy(). Similarly
>>>>   somebody else reported that blkiocg_lookup_group() is eating 6% extra
>>>>   cpu. Though looking at the code I can't think why the overhead of
>>>>   this function is so high. One thing is that it is called with very high
>>>>   frequency (once for every IO).
>>>>
>>>> o For lot of folks blkio controller will be compiled in but they might
>>>>   not have actually created cgroups. Hence optimize the case of root
>>>>   cgroup where we can avoid calling blkiocg_lookup_group() if IO is happening
>>>>   in root group (common case).
>>>>
>>>> Reported-by: Jeff Moyer <jmoyer@redhat.com>
>>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>>
>>> Hi Jens,
>>>
>>> Do you have any concerns regarding this patch?
>>
>> Acked-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> Jens, this is a pretty easy performance regression fixup.  I think it
>> should be pulled in sooner rather than later.  We've also witnessed this
>> slowdown on big performance testing rigs, so it's not just a ramdisk
>> issue.
> 
> Yep, will fold it into 2.6.38, thanks!

Just to be clear, it's queued up in for-linus so it will go to 2.6.38 on
the next push. It was updated last week, this is what it has so far:

Sergey Senozhatsky (1):
      loop: queue_lock NULL pointer derefence in blk_throtl_exit

Stephen M. Cameron (1):
      cciss: make cciss_revalidate not loop through CISS_MAX_LUNS volumes unnecessarily.

Tao Ma (1):
      blktrace: Don't output messages if NOTIFY isn't set.

Tracey Dent (2):
      drivers/block/Makefile: replace the use of <module>-objs with <module>-y
      drivers/block/aoe/Makefile: replace the use of <module>-objs with <module>-y

Vivek Goyal (2):
      cfq: rename a function to give it more appropriate name
      blkio-throttle: Avoid calling blkiocg_lookup_group() for root group

 block/blk-throttle.c       |   10 +++++++++-
 block/cfq-iosched.c        |    6 +++---
 drivers/block/Makefile     |    2 +-
 drivers/block/aoe/Makefile |    2 +-
 drivers/block/cciss.c      |    2 +-
 drivers/block/loop.c       |    3 +++
 kernel/trace/blktrace.c    |    7 +++++++
 7 files changed, 25 insertions(+), 7 deletions(-)

-- 
Jens Axboe

