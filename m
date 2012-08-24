Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2HXH0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:26:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58254 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752611Ab2HXH0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:26:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+JTkk8zp+JJgg1b277iWijPAwxt9cOkuSSKrwX5T
	xRAbtYq2TvDLNu
Message-ID: <1345793168.4331.64.camel@marge.simpson.net>
Subject: Re: [next-20120823] NOHZ: local_softirq_pending 200 on s/r
From: Mike Galbraith <efault@gmx.de>
To: sedat.dilek@gmail.com
Cc: Paul McKenney <paul.mckenney@linaro.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-next <linux-next@vger.kernel.org>
Date: Fri, 24 Aug 2012 09:26:08 +0200
In-Reply-To: <CA+icZUW2aUP=vjBeoksFU=NAVFMJEiBQy6sNKZczzRPEP9kOfw@mail.gmail.com>
References: <CA+icZUW2aUP=vjBeoksFU=NAVFMJEiBQy6sNKZczzRPEP9kOfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 12:04 +0200, Sedat Dilek wrote:

> Jack Winter confirmed to see similiar NOHZ messages also on
> v3.4.9-rt17 kernel (CPU: Core2Duo when no suspend performed):
> 
> [15223.171585] NOHZ: local_softirq_pending 08

These can be caused by blocking while holding local_softirq_lock.

Even with per softirq threads, and then (yet more overhead) splitting
the lock to make sure one softirq type can't block another, _and_ only
griping if the lock for the pending softirq is _not_ held, seems the
little bugger can still be triggered very rarely by syn flood induced
handler bail/raise.  Annoying little gripe :)

-Mike

