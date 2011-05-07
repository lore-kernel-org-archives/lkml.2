Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1EGSWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 14:22:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53812 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab1EGSWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 14:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wI2v6+u9PBVqeEXy8AfDcGqF7D32Qdf43ehIJrLoerFp0CqQIbhMDLNYNlgoM4ebwM
         miyJY7Bv+eVZrhWEkWyyi7ZGhA+CXIe7YPkMNEnVmEtvyMk073h703mkBRvuL5/zh5IX
         B+WfEvMBwIegRQ0KqivDnkukHsGnX7W5lnDMM=
MIME-Version: 1.0
In-Reply-To: <m14o56pppd.fsf@fess.ebiederm.org>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<1304735101-1824-1-git-send-email-ebiederm@xmission.com>
	<1304735101-1824-7-git-send-email-ebiederm@xmission.com>
	<BANLkTi=G-uViB6=8bQ0dRGbw3Gg8V10CRw@mail.gmail.com>
	<m14o56pppd.fsf@fess.ebiederm.org>
Date: Sat, 7 May 2011 20:22:19 +0200
X-Google-Sender-Auth: 45Dw33RVHflrjU9mlEaYPaX7KB0
Message-ID: <BANLkTimkqOVi0+_azj4UyrQkE8sZL1yCyQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] ns: Wire up the setns system call
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 16:09, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> On Sat, May 7, 2011 at 04:25, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>  arch/m68k/include/asm/unistd.h         |    3 ++-
>>>  arch/m68k/kernel/syscalltable.S        |    1 +
>>
>> As the unified syscalltable for m68k/m68knommu is not yet in mainline
>> (planned for
>> 2.6.40), you should also add it to arch/m68k/kernel/entry_mm.S.
>>
>> Gr{oetje,eeting}s,
>
> Like so?
>
> From c06a03281d944ed36e2da02f5374ec6c650e4988 Mon Sep 17 00:00:00 2001
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Sat, 7 May 2011 07:00:24 -0700
> Subject: [PATCH] m68knommu: Wire up the setns system call
>
> It seems I overlooked m68knommu where I wired up this syscall.

You overlooked m68k with MMU. syscalltable.s is used by m68knommu.

> Reported-by:  Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/m68k/kernel/entry_mm.S |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/m68k/kernel/entry_mm.S b/arch/m68k/kernel/entry_mm.S
> index 1359ee6..e048015 100644
> --- a/arch/m68k/kernel/entry_mm.S
> +++ b/arch/m68k/kernel/entry_mm.S
> @@ -754,4 +754,5 @@ sys_call_table:
>        .long sys_open_by_handle_at
>        .long sys_clock_adjtime
>        .long sys_syncfs
> +       .long sys_setns

Yep.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
