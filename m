Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0EEVGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:06:54 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:60966 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab0EEVGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:06:53 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] fat: convert to unlocked_ioctl
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
	<alpine.LFD.2.00.1005051927210.6285@localhost.localdomain>
	<87wrvitd5c.fsf@devron.myhome.or.jp>
	<201005052155.17249.arnd@arndb.de>
Date: Thu, 06 May 2010 06:06:45 +0900
In-Reply-To: <201005052155.17249.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 5 May 2010 21:55:16 +0200")
Message-ID: <87aaset5wa.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> FAT does not require the BKL in its ioctl function, which is already serialized
> through a mutex. Since we're already touching the ioctl code, also fix the
> missing handling of FAT_IOCTL_GET_ATTRIBUTES in the compat code.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

[...]

> The only thing the series really needs to do is to remove the
> usage of the deprecated ->ioctl() operation. This patch makes
> FAT simply use unlocked_ioctl but does not reintroduce the
> BKL.
>
> Does that look better?

Looks good to me. I'll apply this for next window after some tests.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
