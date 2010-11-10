Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0KJIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:25:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab0KJIZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:25:28 -0500
Date: Wed, 10 Nov 2010 09:25:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        kees.cook@canonical.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Restrict unprivileged access to kernel syslog
Message-ID: <20101110082516.GB3341@elte.hu>
References: <1289348309.7380.31.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289348309.7380.31.camel@dan>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> The kernel syslog contains debugging information that is often useful
> during exploitation of other vulnerabilities, such as kernel heap
> addresses.  Rather than futilely attempt to sanitize hundreds (or
> thousands) of printk statements and simultaneously cripple useful
> debugging functionality, it is far simpler to create an option that
> prevents unprivileged users from reading the syslog.
> 
> This patch, loosely based on grsecurity's GRKERNSEC_DMESG, creates the
> dmesg_restrict sysctl.  When set to "0", the default, no restrictions
> are enforced.  When set to "1", only users with CAP_SYS_ADMIN can read
> the kernel syslog via dmesg(8) or other mechanisms.
> 
> v2 adds CONFIG_SECURITY_RESTRICT_DMESG.  When enabled, the default
> sysctl value is set to "1".  When disabled, the default sysctl value is
> set to "0".
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Kees Cook <kees.cook@canonical.com>
> CC: stable <stable@kernel.org>

Acked-by: Ingo Molnar <mingo@elte.hu>

Linus, Andrew, any objections against pushing this trivial control flag upstream out 
of band, after a bit of testing? It's not like it can break anything, and the flag 
is very useful to distros.

Thanks,

	Ingo
