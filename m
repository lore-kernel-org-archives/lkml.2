Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0GNJ5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:57:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47320 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895Ab0GNJ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:57:41 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kmemleak, cpu usage jump out of nowhere
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
Date: Wed, 14 Jul 2010 10:57:33 +0100
In-Reply-To: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
	(Zeno Davatz's message of "Wed, 14 Jul 2010 08:12:48 +0200")
Message-ID: <tnx630ibd2q.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jul 2010 09:57:37.0397 (UTC) FILETIME=[FD3E1250:01CB233A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zeno Davatz <zdavatz@gmail.com> wrote:
> I got a new Intel core-8 i7 processor.
>
> I am on kernel uname -a
>
> Linux zenogentoo 2.6.35-rc5 #97 SMP Tue Jul 13 16:13:25 CEST 2010 i686
> Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz GenuineIntel GNU/Linux
>
> Sometimes in the middle of nowhere all of a sudden all of my 8-cores
> are at 100% CPU usage and my machine really lags and hangs and is not
> useable anymore. Some random process just grabs a bunch CPUs according
> to htop.
>
> dmesg tell me that
>
> kmemleak: 38 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
> kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

These may be related to the NO_BOOTMEM configuration (I sent a patch in
a separate reply).

But even when kmemleak scans the memory, it only uses a single thread
and you should only see a single CPU going to 100%. I don't think
kmemleak scanning can explain why all the 8 cores are going up to 100%.

-- 
Catalin
