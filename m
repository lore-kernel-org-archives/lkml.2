Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab0JLJbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:31:40 -0400
Received: from canuck.infradead.org ([134.117.69.58]:34131 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab0JLJbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:31:39 -0400
Subject: Re: [PATCH] sched: drop all load weight manipulation for RT tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>, stable@kernel.org
In-Reply-To: <1286807811-10568-1-git-send-email-linus.walleij@stericsson.com>
References: <1286807811-10568-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 11:31:16 +0200
Message-ID: <1286875876.29097.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 16:36 +0200, Linus Walleij wrote:
> Load weights are for the CFS, they do not belong in the RT
> task. This makes all RT scheduling classes leave the
> CFS weights alone.
> 
> This fixes a real bug as well: I noticed the following
> phonomena: a process elevated to SCHED_RR forks with
> SCHED_RESET_ON_FORK set, and the child is indeed SCHED_OTHER,
> and the niceval is indeed reset to 0. However the
> weight inserted by set_load_weight() remains at 0. giving the
> task insignificat priority.
> 
> With this fix, the weight is reset to what the task had before
> being elevated to SCHED_RR/SCHED_FIFO.
> 
> Cc: Lennart Poettering <lennart@poettering.net>
> Cc: stable@kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>

Thanks, queued it up, we'll see if anything explodes ;-)
