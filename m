Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0F1UzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:55:18 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:16776 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752766Ab0F1UzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:55:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAMaoKExLd/sX/2dsb2JhbAAHgxbNApEsgSmDCXIE
X-IronPort-AV: E=Sophos;i="4.53,499,1272859200"; 
   d="scan'208";a="69071202"
Message-ID: <4C290C32.4010402@teksavvy.com>
Date: Mon, 28 Jun 2010 16:55:14 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Brian Bloniarz <bmb@athenacr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
References: <4C10EC2A.8060002@fusionio.com> <AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com> <4C1111ED.6020008@fusionio.com> <4C111685.8010400@athenacr.com> <4C27DA4A.3040708@teksavvy.com> <4C284931.2000908@fusionio.com> <4C28A8FC.6040605@teksavvy.com> <4C28AC1E.8070409@athenacr.com> <4C28DCA6.1060503@fusionio.com>
In-Reply-To: <4C28DCA6.1060503@fusionio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/10 01:32 PM, Jens Axboe wrote:
> On 28/06/10 16.05, Brian Bloniarz wrote:
..
>> Links to the patch series that Jens mentions are below. I doubt they
>> apply cleanly to older kernels. Somebody's probably going to need to
>> take a crack at backporting them eventually (I could try, even), but
>> I don't know anybody has yet.
>>
>> Christoph Hellwig (8):
>>        writeback: fix writeback completion notifications
>>        writeback: queue work on stack in writeback_inodes_sb
>>        writeback: enforce s_umount locking in writeback_inodes_sb
>>        writeback: fix writeback_inodes_wb from writeback_inodes_sb
>>        writeback: simplify wakeup_flusher_threads
>>        writeback: simplify and split bdi_start_writeback
>>        writeback: add missing requeue_io in writeback_inodes_wb
>>        writeback: fix pin_sb_for_writeback
>>
>> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=2c99721ec6a55b2c1e7ba94945bbdae454e11308
>> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=ebf51611db2cfa33d056b4428f13275f81732fd5
>> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=de3f848fbc24f71174f3bcc7513b5a3fafb37bac
>> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=e15e123275b3ca3eeb378136046ab78eab214169
>> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=dcac2e708d8f8af1a220dd238027af5b4aedfc12
>> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=8163b53a6bfbfa14ae83f8cdbf536f9c191d3279
>> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=22e53a2ca88690c711a954d3c652b468a5e94272
>> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=7eed7cc254e71352e5e2e642c70a9b04cd28cc76
>
> Yes, that's the series.
..

Those apply/run on 2.6.34 with one minor change to the sixth patch:
Nuke the final one-liner blob from "simplify and split bdi_start_writeback",
getting rid of this part:

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -705,9 +705,8 @@ void laptop_mode_timer_fn(unsigned long data)
  	 * We want to write everything out, not just down to the dirty
  	 * threshold
  	 */
-
  	if (bdi_has_dirty_io(&q->backing_dev_info))
-		bdi_start_writeback(&q->backing_dev_info, NULL, nr_pages);
+		bdi_start_writeback(&q->backing_dev_info, nr_pages);
  }
  
  /*
----

The rest applied cleanly, and I don't see any obvious need for an alternative
to the deleted line above.

Cheers



