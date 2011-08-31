Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1HaMsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:48:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44098 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab1HaMsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:48:20 -0400
MIME-Version: 1.0
Date: Wed, 31 Aug 2011 18:18:19 +0530
Message-ID: <CA+OjSzzrYggQjDrgd6m+oF1sZkJFzf-3vSedAT3DAD9V2jTC3A@mail.gmail.com>
Subject: General question about TASK_INTERRUPTIBLE and schedule_timeout()
From: sifram rajas <sifram.rajas@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a general question about the following 2 lines of code I see
all over the kernel:
1         set_current_state(TASK_INTERRUPTIBLE) ;
2         schedule_timeout(<some value>);

In the above code, if we encounter an interrupt after executing line
1, we will end up
call schedule() from the architecture specific code for CONFIG_PREEMPT
kernels, after
the interrupt handler has been invokled.

This will cause the current task to sleep interruptibly forever
instead of for a certain timeout interval.

Won't this defeat the purpose of the above code to schedule out or
sleep for a certain finite timeout ?
If yes, then what are the techniques to solve this problem ?


Thanks,
Sifram.
