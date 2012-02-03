Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab2BCJu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:50:56 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61548 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab2BCJuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:50:52 -0500
Message-ID: <1328262648.2157.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] perf, tool: Fix perf stack to non executable on x86_64
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Fri, 03 Feb 2012 10:50:48 +0100
In-Reply-To: <1328100848-5630-1-git-send-email-jolsa@redhat.com>
References: <1328100848-5630-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 février 2012 à 13:54 +0100, Jiri Olsa a écrit :
> By adding following objects:
>   bench/mem-memset-x86-64-asm.o
>   bench/mem-memcpy-x86-64-asm.o
> the x86_64 perf binary ended up with executable stack.
> 
> The reason was that above objects are assembler sourced and
> are missing the GNU-stack note section. In such case the linker
> assumes that the final binary should not be restricted at all
> and mark the stack as RWX.
> 
> Adding section ".note.GNU-stack" definition to mentioned objects,
> with all flags disabled, thus omiting those objects from linker
> stack flags decision.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---

Good catch, thanks !

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


