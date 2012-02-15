Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2BOQPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:15:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab2BOQPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:15:44 -0500
Date: Wed, 15 Feb 2012 17:06:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120215160652.GA17680@redhat.com>
References: <20120215143606.GA14037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215143606.GA14037@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not a comment, but the question. I am just curious...

> +/*
> + * We don't expose real in-memory order of objects for security
> + * reasons, still the comparison results should be suitable for
> + * sorting. Thus, we obfuscate kernel pointers values and compare
> + * the production instead.
> + */
> +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
> +
> +static long kptr_obfuscate(long v, int type)
> +{
> +       return (v ^ cookies[type][0]) * cookies[type][1];
> +}

OK, but why do we need this per type? Just to add more obfuscation
or there is another reason?

> +static __init int kcmp_cookies_init(void)
> +{
> +       int i;
> +
> +       get_random_bytes(cookies, sizeof(cookies));
> +
> +       for (i = 0; i < KCMP_TYPES; i++)
> +               cookies[i][1] |= (~(~0UL >>  1) | 1);

I am puzzled, help ;) this is equal to

		cookies[i][1] |= -LONG_MAX;
or
		cookies[i][1] |= (LONG_MIN | 1);

for what? why do we want to set these 2 bits (MSB and LSB) ?

Oleg.

