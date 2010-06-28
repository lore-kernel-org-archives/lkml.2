Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0F1OFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:05:22 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:24887 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751378Ab0F1OFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:05:21 -0400
Message-ID: <4C28AC1E.8070409@athenacr.com>
Date: Mon, 28 Jun 2010 10:05:18 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Jens Axboe <jaxboe@fusionio.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
References: <4C10EC2A.8060002@fusionio.com> <AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com> <4C1111ED.6020008@fusionio.com> <4C111685.8010400@athenacr.com> <4C27DA4A.3040708@teksavvy.com> <4C284931.2000908@fusionio.com> <4C28A8FC.6040605@teksavvy.com>
In-Reply-To: <4C28A8FC.6040605@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 09:51 AM, Mark Lord wrote:
> On 28/06/10 03:03 AM, Jens Axboe wrote:
>> On 2010-06-28 01:10, Mark Lord wrote:
>>> On 10/06/10 12:44 PM, Brian Bloniarz wrote:
> ..
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=15906 has links to the
>>>> downstream bugs.
>>> ..
>>>
>>> Jens, this bug has been biting my servers badly here for the past
>>> few months -- umount after a backup (from ext4 to ext4) takes 3-4
>>> minutes
>>> instead of the expected 3-4 seconds.
>>>
>>> Is there a patch file for this against 2.6.34 that I (and others)
>>> could use?
>>
>> It's the patch series from Christoph in my for-linus branch, I intend
>> to push it upstream when Linus is back and taking patches.
> ..
> 
> Still looking for a *patch* to fix  this here.
> 
> I found these two:
> 
> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=e913fc825dc685a444cb4c1d0f9d32f372f5986
> 
> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=30fd1e551a730d942e91109762c942786be0ef7c
> 
> 
> But they don't apply cleanly to 2.6.34.
> 
> Anyone?

Don't use those, they have bugs and have since been reverted.

Links to the patch series that Jens mentions are below. I doubt they
apply cleanly to older kernels. Somebody's probably going to need to
take a crack at backporting them eventually (I could try, even), but
I don't know anybody has yet.

Christoph Hellwig (8):
      writeback: fix writeback completion notifications
      writeback: queue work on stack in writeback_inodes_sb
      writeback: enforce s_umount locking in writeback_inodes_sb
      writeback: fix writeback_inodes_wb from writeback_inodes_sb
      writeback: simplify wakeup_flusher_threads
      writeback: simplify and split bdi_start_writeback
      writeback: add missing requeue_io in writeback_inodes_wb
      writeback: fix pin_sb_for_writeback

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=2c99721ec6a55b2c1e7ba94945bbdae454e11308
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=ebf51611db2cfa33d056b4428f13275f81732fd5
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=de3f848fbc24f71174f3bcc7513b5a3fafb37bac
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=e15e123275b3ca3eeb378136046ab78eab214169
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=dcac2e708d8f8af1a220dd238027af5b4aedfc12
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=8163b53a6bfbfa14ae83f8cdbf536f9c191d3279
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=22e53a2ca88690c711a954d3c652b468a5e94272
http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commitdiff;h=7eed7cc254e71352e5e2e642c70a9b04cd28cc76
