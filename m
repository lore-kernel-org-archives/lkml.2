Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1EGOJq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 10:09:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60569 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab1EGOJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 10:09:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Subject: Re: [PATCH 7/7] ns: Wire up the setns system call
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<1304735101-1824-1-git-send-email-ebiederm@xmission.com>
	<1304735101-1824-7-git-send-email-ebiederm@xmission.com>
	<BANLkTi=G-uViB6=8bQ0dRGbw3Gg8V10CRw@mail.gmail.com>
Date: Sat, 07 May 2011 07:09:34 -0700
In-Reply-To: <BANLkTi=G-uViB6=8bQ0dRGbw3Gg8V10CRw@mail.gmail.com> (Geert
	Uytterhoeven's message of "Sat, 7 May 2011 10:27:17 +0200")
Message-ID: <m14o56pppd.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+RarPqmMKsCFu6HctHCz0IV1kwFUMMWPA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Sat, May 7, 2011 at 04:25, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>  arch/m68k/include/asm/unistd.h         |    3 ++-
>>  arch/m68k/kernel/syscalltable.S        |    1 +
>
> As the unified syscalltable for m68k/m68knommu is not yet in mainline
> (planned for
> 2.6.40), you should also add it to arch/m68k/kernel/entry_mm.S.
>
> Gr{oetje,eeting}s,

Like so?

>From c06a03281d944ed36e2da02f5374ec6c650e4988 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat, 7 May 2011 07:00:24 -0700
Subject: [PATCH] m68knommu: Wire up the setns system call

It seems I overlooked m68knommu where I wired up this syscall.

Reported-by:  Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/m68k/kernel/entry_mm.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/kernel/entry_mm.S b/arch/m68k/kernel/entry_mm.S
index 1359ee6..e048015 100644
--- a/arch/m68k/kernel/entry_mm.S
+++ b/arch/m68k/kernel/entry_mm.S
@@ -754,4 +754,5 @@ sys_call_table:
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_setns
 
-- 
1.7.5.1.217.g4e3aa

