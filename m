Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1ERIgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 04:36:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52889 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1ERIgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 04:36:05 -0400
Date: Wed, 18 May 2011 10:35:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/4 v2] watchdog: disable watchdog when thresh is zero
Message-ID: <20110518083551.GE14805@elte.hu>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <1305588901-8141-3-git-send-email-msb@chromium.org>
 <20110517071018.GE22305@elte.hu>
 <20110518033647.GB11023@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518033647.GB11023@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@chromium.org> wrote:

> +extern int watchdog_thresh;
>  struct ctl_table;
> -extern int proc_dowatchdog_enabled(struct ctl_table *, int ,
> -			void __user *, size_t *, loff_t *);
> +extern int __proc_dowatchdog(struct ctl_table *, int ,
> +			     void __user *, size_t *, loff_t *);
> +#define proc_dowatchdog_enabled __proc_dowatchdog
> +#define proc_dowatchdog_thresh __proc_dowatchdog

i like the other aspects of your patch but this one is a no-no, we do not use 
1970's tech to obfuscate nice C code! :-)

If the argument list is annoying then introduce a helper structure. But having 
it longer is no big issue either. Try to shorten the function names if 
possible.

Sidenote, the sysctl code has been misdesigned a bit: it should be possible to 
add sysctls in .c files and not centralize it all into kernel/sysctl.c 
forcibly: we could should have a central static array by using a .sysctl_data 
section or such. Anyone wanna fix/improve that?

	Ingo
