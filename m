Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2EUSRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:17:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46413 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757941Ab2EUSRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:17:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX188lblVBF88RewW7QrGwraen0FAHSipXAU168fVh2
	RwF2c5idEJkMbJ
Message-ID: <1337624236.5476.16.camel@marge.simpson.net>
Subject: Re: [PATCH 0/2] RFC: readd fair sleepers for server systems
From: Mike Galbraith <efault@gmx.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Date: Mon, 21 May 2012 20:17:16 +0200
In-Reply-To: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 17:45 +0200, Martin Schwidefsky wrote: 
> our performance team found a performance degradation with a recent
> distribution update in regard to fair sleepers (or the lack of fair
> sleepers). On s390 we used to run with fair sleepers disabled.
> 
> We see the performance degradation with our network benchmark and fair
> sleepers enabled, the largest hit is on virtual connections:

I can see you wanting the feature back.  You guys apparently do not
generally run mixed loads on your boxen, else you wouldn't want to turn
the scheduler into a tick granularity scheduler, but why compile time?
If the fast path branch isn't important, and given it only became
important while I was trying to scrape a few cycles together, why not
just restore the feature as it used to exist under the pretext that you
need it, and others may as well, so we eat the branch in the interest of
general flexibility, and call removal a booboo?

-Mike

