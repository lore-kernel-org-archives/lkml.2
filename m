Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0EMNfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 09:35:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab0EMNfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 09:35:51 -0400
Date: Thu, 13 May 2010 15:35:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Carsten Emde <C.Emde@osadl.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       And rew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/4] tracing/sched: Fix task states in sched switch event
Message-ID: <20100513133539.GA17107@elte.hu>
References: <RYmXFZH5FML2.rJxWwvD3@ce.dyn.web-alm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <RYmXFZH5FML2.rJxWwvD3@ce.dyn.web-alm.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0043]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Carsten Emde <C.Emde@osadl.org> wrote:

> Hi Ingo,
> 
> > Hm, this is totally unreadable. What does 'TASK_STATE_X' mean??
> Would this be better?
> +#define MAKE_TASK_STATE_STRING(num) TASK_STATE_##num " (" DESCR_TASK_STATE_##num ")"
>  static const char *task_state_array[] = {
> -	"R (running)",		/*   0 */
> -	"S (sleeping)",		/*   1 */
> -	"D (disk sleep)",	/*   2 */
> -	"T (stopped)",		/*   4 */
> -	"t (tracing stop)",	/*   8 */
> -	"Z (zombie)",		/*  16 */
> -	"X (dead)",		/*  32 */
> -	"x (dead)",		/*  64 */
> -	"K (wakekill)",		/* 128 */
> -	"W (waking)",		/* 256 */
> +	MAKE_TASK_STATE_STRING(0),
> +	MAKE_TASK_STATE_STRING(1),
> +	MAKE_TASK_STATE_STRING(2),
> +	MAKE_TASK_STATE_STRING(4),
> +	MAKE_TASK_STATE_STRING(8),
> +	MAKE_TASK_STATE_STRING(16),
> +	MAKE_TASK_STATE_STRING(32),
> +	MAKE_TASK_STATE_STRING(64),
> +	MAKE_TASK_STATE_STRING(128),
> +	MAKE_TASK_STATE_STRING(256)

The whole enumeration there is pointless in that .c file - it tells nothing to 
the code reader.

If it cannot be expressed in a meaningful way then introduce 
TASK_STATE_STRINGS_INIT construct that is defined next to the strings (in a .h 
file or so) - that way it's a coherent whole.

Thanks,

	Ingo
