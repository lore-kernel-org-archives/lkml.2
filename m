Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0KILYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:24:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37926 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab0KILYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:24:20 -0500
Date: Tue, 9 Nov 2010 12:23:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Restrict unprivileged access to kernel syslog
Message-ID: <20101109112350.GA29800@elte.hu>
References: <1289273338.6287.128.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289273338.6287.128.camel@dan>
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
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> ---
>  Documentation/sysctl/kernel.txt |   11 +++++++++++
>  include/linux/kernel.h          |    1 +
>  kernel/printk.c                 |    2 ++
>  kernel/sysctl.c                 |    9 +++++++++
>  security/commoncap.c            |    2 ++
>  5 files changed, 25 insertions(+), 0 deletions(-)

> +int dmesg_restrict = 0;

The initialization to zero is implicit, no need to write it out.

Also, it would also be useful to have a CONFIG_SECURITY_RESTRICT_DMESG=y option 
introduced by your patch as well, which flag allows a distro or user to disable 
unprivileged syslog reading via the kernel config.

Thanks,

	Ingo
