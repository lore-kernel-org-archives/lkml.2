Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab1FYKFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 06:05:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab1FYKFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 06:05:11 -0400
Date: Sat, 25 Jun 2011 12:04:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jonas Bonn <jonas@southpole.se>
Cc: rusty@rustcorp.com.au, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, monstr@monstr.eu, cmetcalf@tilera.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] modules: add default loader hook implementations
Message-ID: <20110625100449.GA19097@elte.hu>
References: <1308987512-6583-1-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308987512-6583-1-git-send-email-jonas@southpole.se>
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


* Jonas Bonn <jonas@southpole.se> wrote:

> +/* This configures the module loader code to use the default implementations
> + * for the architecture specific hooks.  Architectures should set a #define
> + * for each of the hooks that it needs to override.
> + */

please use the standard (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

(there are similar problems elsewhere in the patch as well.)

Also, and more importantly, don't we generally do such things via 
__weak aliases, because the result looks cleaner and needs no changes 
for architectures beyond the removal of the generic functions? We 
have excluded broken toolchains that miscompile/mislink __weak IIRC 
so __weak ought to work.

Thanks,

	Ingo
