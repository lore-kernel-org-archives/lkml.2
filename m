Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2FNTTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 15:19:48 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:59363 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2FNTTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 15:19:46 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: swarren@nvidia.com
Cc: linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com,
        linux-arm-kernel@lists.infradead.org, jic23@cam.ac.uk, kay@vrfy.org
Subject: Follow-up to remaining issue with alignment of __log_buf in printk.c
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 14 Jun 2012 21:19:31 +0200
Message-ID: <87aa05vgzg.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Stephen and others,

I have a XScale PXA based board with has the alignement issue which makes the
kernel trap during its early stage.

I wonder what is the status now, is there a fix available ?

I have tracked what happens on PXA. The pxa is an ARM v5TE chip. The new printk
version you submitted is translated to the following assembly on the line :
        msg->ts_nsec = local_clock();
Into:
=> 0xc001bbe0 <log_store+496>:	strd	r0, [r4, r5]

In ARMv5, the "strd" assembly opcode expects the address to be 64bits aligned,
hence the bug.

Now the solutions I have seen so far in the mailing lists :
 - #define LOG_ALIGN (__alignof__(u64))
   Does always work.
 - #define LOG_ALIGN (__alignof__(struct log))
   Doesn't work with my toolchain, as __alignof__(struct log) is 4, not 8

What are you intending to do to solve the ARMv5 issue ? Are you waiting for
someone to submit a patch ?

Cheers.

-- 
Robert
