Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422845Ab2KNNEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:04:44 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58605 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422817Ab2KNNEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:04:43 -0500
MIME-Version: 1.0
In-Reply-To: <50A3130F.7010001@gmail.com>
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
	<50A3130F.7010001@gmail.com>
Date: Wed, 14 Nov 2012 15:04:42 +0200
X-Google-Sender-Auth: OJMuLSimlG4_NmUZ-cpUunuNIxU
Message-ID: <CAE7jHC-Rbz0zA7UAAzs8iX9mHAC0bLUZY-igM8k7R258_sE0mA@mail.gmail.com>
Subject: Re: [PATCH] LDT - Linux Driver Template
From: Constantine Shulyupin <const@makelinux.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 5:42 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 14/11/12 05:46, Constantine Shulyupin wrote:
>> From: Constantine Shulyupin <const@MakeLinux.com>
>> +     if (kfifo_is_empty(&in_fifo)) {
>
> Doesn't this require locking against whatever is filling the fifo?
I seems doesn't.
Note from include/linux/kfifo.h
/*
 * Note about locking : There is no locking required until only * one reader
 * and one writer is using the fifo and no kfifo_reset() will be * called
 *  kfifo_reset_out() can be safely used, until it will be only called
 * in the reader thread.
 *  For multiple writer and one reader there is only a need to lock the writer.
 * And vice versa for only one writer and multiple reader there is only a need
 * to lock the reader.
 */

>> +     if (mutex_lock_interruptible(&read_lock)) {
> The read_lock is only used here, so would only protect against
> concurrent reads. Isn't the read for a device function already
> synchronised against itself by the caller?
I can't find locking for read/write in sys_read, vfs_read
I just found lock misc_mtx for misc_open, misc_register.

>> +     ret = kfifo_from_user(&out_fifo, buf, count, &copied);
> Shouldn't this function be grabbing fifo_lock to prevent concurrent
> access to the fifo by the tasklet function? write_lock has the same
> issues described for read_lock above.

Accordingly note about kfifo locking is shouldn't.
kfifo supports asynchronous i/o.

Thank you.
