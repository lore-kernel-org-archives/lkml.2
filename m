Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0LVRN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 12:13:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45682 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0LVRN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 12:13:27 -0500
Date: Wed, 22 Dec 2010 18:13:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, davem@davemloft.net, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, eparis@parisplace.org
Subject: Re: [PATCH v5] kptr_restrict for hiding kernel pointers
Message-ID: <20101222171307.GA25611@elte.hu>
References: <1293037246.9820.236.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293037246.9820.236.camel@dan>
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

> +	case 'K':
> +		/*
> +		 * %pK cannot be used in IRQ context because its test
> +		 * for CAP_SYSLOG would be meaningless.
> +		 */
> +		if (in_irq() || in_serving_softirq() || in_nmi())
> +			WARN_ONCE(1, "%%pK used in interrupt context.\n");

Hm, that bit looks possibly broken - some useful warning in irq context could print 
a pointer into the syslog and this would generate a second warning? That probably 
would crash as it recurses back into the printk code?

Instead a warning could be inserted into the generated output instead, for example 
'pK-error' (carefully staying within pointer length limits).

Also, it would be nice to see a couple of actual %pK usage sites submitted as well - 
instead of this pure infrastructure patch.

	Ingo
