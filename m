Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1GBGuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 02:50:22 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39680 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1GBGuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 02:50:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110702033853.220897627@goodmis.org>
References: <20110702030435.308336775@goodmis.org> <20110702033853.220897627@goodmis.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 2 Jul 2011 02:50:00 -0400
X-Google-Sender-Auth: AOc9UiBznS2zaAQXcOde6Lj05nE
Message-ID: <CAMjpGUfHw-CO=ydCew5FqG0RLQOMk8+NpVjvBdV4Nv-tiDavqg@mail.gmail.com>
Subject: Re: [patch 03/11] blackfin/irqs: Do not trace arch_local_{*,irq_*} functions
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 23:04, Steven Rostedt wrote:
> Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
> Although they are marked inline, gcc may still make a function out of
> them and add it to the pool of functions that are traced by the function
> tracer. This can cause undesirable results (kernel panic, triple faults,
> etc).
>
> Add the notrace notation to prevent them from ever being traced.

what about putting the markings in include/asm-generic/irqflags.h ?
then you wouldnt have to update every arch (or at least, not as much).
-mike
