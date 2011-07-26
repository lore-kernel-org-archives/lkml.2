Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1GZVqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:46:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65080 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1GZVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:46:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU3+ceB+uDY6q2WyBvaTsJr-v9sRF7DDr_omNMf49o3Kg@mail.gmail.com>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
	<1310462166-31469-14-git-send-email-tj@kernel.org>
	<CAE9FiQU3+ceB+uDY6q2WyBvaTsJr-v9sRF7DDr_omNMf49o3Kg@mail.gmail.com>
Date: Tue, 26 Jul 2011 23:46:11 +0200
X-Google-Sender-Auth: 5FyBevUTQ68PZGvjA0BH7ksbSR4
Message-ID: <CAOS58YOYOMNmLTn=MLdObwfUPLb-xOr1Xw7aLoEWcDb8esAX4A@mail.gmail.com>
Subject: Re: [PATCH 13/13] memblock, x86: Replace memblock_x86_reserve/free_range()
 with generic ones
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Tue, Jul 26, 2011 at 11:06 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> Wonder if we have a new function like
>
> __memblock_reserve(addr, size, name)
>
> in mm/memblock.c
>
> so could keep string for debug purpose instead of using _RET_IP_.
>
> with that, we can figure out what is in exact reserved position with boot log.

If you look at the current users, the caller function name is unique
except for one or two cases, so we can already tell who's doing what
even without consulting the exact IP.  I can't see much point in
providing debug strings explicitly.  The only benefit would be that it
would be prettier but these are purely debug messages.  One thing
which might make sense is preserving _RET_IP_ of callers of alloc
functions so that reserve can show who's allocating instead of
printing the alloc function each time.

Thanks.

-- 
tejun
