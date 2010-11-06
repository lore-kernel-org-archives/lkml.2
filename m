Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab0KFOXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:23:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51355 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab0KFOXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:23:55 -0400
MIME-Version: 1.0
In-Reply-To: <201011062018.ADJ30249.OVOOJFMFHQFStL@I-love.SAKURA.ne.jp>
References: <201011060307.GIG13040.OFFJOVHMSFLOtQ@I-love.SAKURA.ne.jp>
 <20101105200245.GA1645@suse.de> <201011062018.ADJ30249.OVOOJFMFHQFStL@I-love.SAKURA.ne.jp>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 6 Nov 2010 15:23:38 +0100
Message-ID: <AANLkTi=BL4N7T1VDU2Pxd3pmm-=TwzRN_JqWeMFahEY=@mail.gmail.com>
Subject: Re: [2.6.37-rc1] udevd-event prints errors.
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: gregkh@suse.de, cbouatmailru@gmail.com, ak@linux.intel.com,
        axboe@kernel.dk, shemminger@vyatta.com, ebiederm@xmission.com,
        stern@rowland.harvard.edu, James.Bottomley@suse.de,
        akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
        randy.dunlap@oracle.com, tj@kernel.org, davem@davemloft.net,
        perex@perex.cz, tiwai@suse.de, mingo@elte.hu, a.p.zijlstra@chello.nl,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 6, 2010 at 12:18, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:

>> Other than that, everything works ok, right?
> Right.

It's something that should be fixed in the udev rules. This is the
fixed line, we used in later releases. It adds an additional match to
prevent the warning you see:
  SUBSYSTEM=="scsi", KERNEL=="[0-9]*:[0-9]*", WAIT_FOR_SYSFS="ioerr_cnt"

All of that is not needed with current kernels, it was a hacky
workaround for broken sysfs/event timing issues we had years ago.

Kay
