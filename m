Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965183Ab1GMJZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:25:47 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:40338 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965133Ab1GMJZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:25:45 -0400
Date: Wed, 13 Jul 2011 10:25:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do_signal: simplify the TS_RESTORE_SIGMASK logic
Message-ID: <20110713102520.0065c7de@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110710182203.GA27979@redhat.com>
References: <20110710182203.GA27979@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011 20:22:03 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> 1. do_signal() looks at TS_RESTORE_SIGMASK and calculates the
>    mask which should be stored in the signal frame, then it
>    passes "oldset" to the callees, down to setup_rt_frame().
> 
>    This is ugly, setup_rt_frame() can do this itself and nobody
>    else needs this sigset_t. Move this code into setup_rt_frame.
> 
> 2. do_signal() also clears TS_RESTORE_SIGMASK if handle_signal()
>    succeeds.
> 
>    We can move this to setup_rt_frame() as well, this avoids the
>    unnecessary checks and makes the logic more clear.
> 
> 3. use set_current_blocked() instead of sigprocmask(SIG_SETMASK),
>    sigprocmask() should be avoided.

Could you please mention commit e6fa16ab "signal: sigprocmask() should
do retarget_shared_pending()", since it's not immediately obvious in
this changelog why sigprocmask() should be avoided.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

FWIW,

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
