Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab1GFJlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:41:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46181 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1GFJla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:41:30 -0400
MIME-Version: 1.0
In-Reply-To: <1309870814-14181-2-git-send-email-ian.campbell@citrix.com>
References: <20110705111525.GR17941@sun>
	<1309870814-14181-2-git-send-email-ian.campbell@citrix.com>
Date: Wed, 6 Jul 2011 12:41:29 +0300
X-Google-Sender-Auth: bak5p-NyC9PkEHEgCde-vX6lZ48
Message-ID: <CAOJsxLHwvMZaR-09u2iTpu2ksCxypLJXG0Cw6Aeu5zWcLYYxpg@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: make 64 bit ret_from_fork a little more similar
 to 32 bit
From: Pekka Enberg <penberg@kernel.org>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 4:00 PM, Ian Campbell <ian.campbell@citrix.com> wrote:
> The 64 bit version resets EFLAGS before calling schedule_tail() and
> therefore leaves EFLAGS.IF clear. 32 bit resets EFLAGS after calling
> schedule_tail() and therefore leaves EFLAGS.IF set. I don't think
> there is any practical difference between the two approaches since
> interrupts are actually reenabled within schedule_tail
> (schedule_tail->finish_task_switch->finish_lock_switch->raw_spin_unlock_irq->...->local_irq_enable)
> so arbitrarily pick the 32 bit version and make 64 bit look like that.
>
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: x86@kernel.org

Reviewed-by: Pekka Enberg <penberg@kernel.org>
