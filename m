Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2HNLJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:09:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54270 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2HNLJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com>
References: <1344938848-29606-1-git-send-email-ldewangan@nvidia.com>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 14 Aug 2012 13:08:38 +0200
X-Google-Sender-Auth: sZ91Qg3nbAfU5RO9tK_8dBAqTPE
Message-ID: <CAH+eYFC5WPbwrfMh9tN2ocQOj46a2E2QmjYCLvk2_zHOVCGP1Q@mail.gmail.com>
Subject: Re: [PATCH] regulator: disable supply regulator if it is enabled for boot-on
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/14 Laxman Dewangan <ldewangan@nvidia.com>:
> If supply regulator is enabled because of boot-on (not always-on)
> then disable regulator need to be call if regulator have some
> user or full constraint has been enabled.
> This will make sure that reference count of supply regulator
> is in sync with child regulator's state.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

 =============================================
 [ INFO: possible recursive locking detected ]
 3.4.0+ #71 Not tainted
 ---------------------------------------------
 swapper/0/1 is trying to acquire lock:
  (&rdev->mutex){+.+.+.}, at: [<c0306c60>] regulator_disable+0x2c/0x6c

 but task is already holding lock:
  (&rdev->mutex){+.+.+.}, at: [<c0a0d1f4>] regulator_init_complete+0x70/0x1c0

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&rdev->mutex);
   lock(&rdev->mutex);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 2 locks held by swapper/0/1:
  #0:  (regulator_list_mutex){+.+.+.}, at: [<c0a0d1a8>]
regulator_init_complete+0x24/0x1c0
  #1:  (&rdev->mutex){+.+.+.}, at: [<c0a0d1f4>]
regulator_init_complete+0x70/0x1c0

 stack backtrace:
 [<c0017ab4>] (unwind_backtrace+0x0/0x148) from [<c06e86a0>]
(dump_stack+0x20/0x24)
 [<c06e86a0>] (dump_stack+0x20/0x24) from [<c008e6d0>]
(check_deadlock+0x358/0x44c)
 [<c008e6d0>] (check_deadlock+0x358/0x44c) from [<c008f7b4>]
(validate_chain+0x410/0x710)
 [<c008f7b4>] (validate_chain+0x410/0x710) from [<c0090034>]
(__lock_acquire+0x580/0xb3c)
 [<c0090034>] (__lock_acquire+0x580/0xb3c) from [<c0090690>]
(lock_acquire+0xa0/0x138)
 [<c0090690>] (lock_acquire+0xa0/0x138) from [<c06ea0d0>]
(mutex_lock_nested+0x5c/0x364)
 [<c06ea0d0>] (mutex_lock_nested+0x5c/0x364) from [<c0306c60>]
(regulator_disable+0x2c/0x6c)
 [<c0306c60>] (regulator_disable+0x2c/0x6c) from [<c0a0d2cc>]
(regulator_init_complete+0x148/0x1c0)
 [<c0a0d2cc>] (regulator_init_complete+0x148/0x1c0) from [<c0008644>]
(do_one_initcall+0x50/0x1a8)
 [<c0008644>] (do_one_initcall+0x50/0x1a8) from [<c09ee3dc>]
(kernel_init+0xf4/0x1d4)
 [<c09ee3dc>] (kernel_init+0xf4/0x1d4) from [<c0010cfc>]
(kernel_thread_exit+0x0/0x8)
