Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0IDGsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 02:48:05 -0400
Received: from freeflow.nu ([178.79.134.28]:55402 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab0IDGsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 02:48:04 -0400
Message-ID: <4C81EB93.4090304@kernel.org>
Date: Sat, 04 Sep 2010 09:47:47 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] x86-64: Disable preemption when using TS_USEDFPU
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com> <1283563039-3466-6-git-send-email-brgerst@gmail.com>
In-Reply-To: <1283563039-3466-6-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 4.9.2010 4.17, Brian Gerst wrote:
> Consolidates code and fixes the below race for 64-bit.
>
> commit 9fa2f37bfeb798728241cc4a19578ce6e4258f25
> Author: torvalds<torvalds>
> Date:   Tue Sep 2 07:37:25 2003 +0000
>
>      Be a lot more careful about TS_USEDFPU and preemption
>
>      We had some races where we testecd (or set) TS_USEDFPU together
>      with sequences that depended on the setting (like clearing or
>      setting the TS flag in %cr0) and we could be preempted in between,
>      which screws up the FPU state, since preemption will itself change
>      USEDFPU and the TS flag.
>
>      This makes it a lot more explicit: the "internal" low-level FPU
>      functions ("__xxxx_fpu()") all require preemption to be disabled,
>      and the exported "real" functions will make sure that is the case.
>
>      One case - in __switch_to() - was switched to the non-preempt-safe
>      internal version, since the scheduler itself has already disabled
>      preemption.
>
>      BKrev: 3f5448b5WRiQuyzAlbajs3qoQjSobw
>
> Signed-off-by: Brian Gerst<brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>

