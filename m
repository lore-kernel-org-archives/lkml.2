Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0KNMgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 07:36:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab0KNMgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 07:36:11 -0500
Date: Sun, 14 Nov 2010 13:35:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, James Morris <jmorris@namei.org>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix dmesg_restrict build failure with CONFIG_EMBEDDED=y
 and CONFIG_PRINTK=n
Message-ID: <20101114123517.GA11808@elte.hu>
References: <1289669176.16461.12.camel@Joe-Laptop>
 <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
 <1289672721.3090.349.camel@Dan>
 <AANLkTi=4AQst9bNXrvwN6sZc2CM9rccYbERYYQkVK99q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=4AQst9bNXrvwN6sZc2CM9rccYbERYYQkVK99q@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> (The diffstat says that this adds more lines than it removes, but that
> is misleading: it is due to actually commenting the rule that checks
> are done open-time for /proc/kmsg)
> 
>                          Linus
>
>  include/linux/security.h   |   11 +++++------
>  kernel/printk.c            |   15 ++++++++++++---
>  kernel/sysctl.c            |    2 +-
>  security/commoncap.c       |    7 +------
>  security/security.c        |    4 ++--
>  security/selinux/hooks.c   |    4 ++--
>  security/smack/smack_lsm.c |    4 ++--
>  7 files changed, 25 insertions(+), 22 deletions(-)

I gave it some testing in -tip and your patch also solves the !EMBEDDED build bug 
(and it also still restricts unprivileged dmesg output when desired), so:

 Acked-by: Ingo Molnar <mingo@elte.hu>
 Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
