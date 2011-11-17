Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1KQIBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:01:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57347 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab1KQIBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:01:17 -0500
MIME-Version: 1.0
In-Reply-To: <20111117060215.GB15644@zhy>
References: <1321508072-23853-1-git-send-email-tom.leiming@gmail.com>
	<1321508072-23853-2-git-send-email-tom.leiming@gmail.com>
	<20111117060215.GB15644@zhy>
Date: Thu, 17 Nov 2011 16:01:16 +0800
Message-ID: <CACVXFVPo410dy5Mz_Kd3vC=iLazgg8MuPpHnMKfUbUypfXaGUg@mail.gmail.com>
Subject: Re: [PATCH 2/2] lockdep: print lock name for lockdep_init_error
From: Ming Lei <tom.leiming@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your review.

On Thu, Nov 17, 2011 at 2:02 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Thu, Nov 17, 2011 at 01:34:32PM +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch prints the name of the lock which is acquired
>> before lockdep_init is called, so that user can easily find
>> which lock trigged the lockdep init error warning.
>
> Should we care about that?

Yes, we should, see below.

>
> I think lockdep_init() called early enough give more hint.
> Such as be the first C function called by arch.

Maybe not early enough, before start_kernel is executed, arch
asm code still can call some C function, can't it?

The patch is just an improvement on original lockdep_init_error
detect, plus fix on incorrect debug message.

thanks,
-- 
Ming Lei
