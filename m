Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab1CWNM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:12:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58446 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932671Ab1CWNMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:12:24 -0400
Date: Wed, 23 Mar 2011 14:12:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] vsprintf: introduce %pT format specifier
Message-ID: <20110323131213.GA25467@elte.hu>
References: <1300884395-13835-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300884395-13835-1-git-send-email-namhyung@gmail.com>
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


* Namhyung Kim <namhyung@gmail.com> wrote:

> The %pT format specifier is for stack backtrace. Its handler
> sprint_trace() does symbol lookup using (address-1) to ensure
> the address will not point outside of the function.
> 
> If there is a tail-call to the function marked "noreturn",
> gcc optimized out the code after the call then causes saved
> return address points outside of the function (i.e. the start
> of the next function), so pollutes call trace somewhat.
> This patch will fix it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: linux-arch@vger.kernel.org
> ---
>  include/linux/kallsyms.h |    7 +++++++
>  kernel/kallsyms.c        |   40 ++++++++++++++++++++++++++++++++++++++++
>  lib/vsprintf.c           |    7 ++++++-
>  3 files changed, 53 insertions(+), 1 deletions(-)

Looks useful. Please include before/after stack dump examples in the changelog, 
to show the difference.

Thanks,

	Ingo
