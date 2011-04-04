Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1DDKFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:05:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34806 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754357Ab1DDKFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:05:46 -0400
Date: Mon, 4 Apr 2011 11:05:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 16/18] 2.6.40: x86 idle APM: remove
 deprecated apm_cpu_idle()
Message-ID: <20110404110558.55301a8b@lxorguk.ukuu.org.uk>
In-Reply-To: <4D97E018.1090504@linux.vnet.ibm.com>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
	<1301725380-10579-1-git-send-email-lenb@kernel.org>
	<5d9716021b20302ece48fd486bbad9bcb2502353.1301724243.git.len.brown@intel.com>
	<20110402124054.49c3a3f4@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.02.1104021529580.18682@x980>
	<20110402220021.74ecdb5b@lxorguk.ukuu.org.uk>
	<4D97E018.1090504@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are other problems too. This design of pm_idle has been copied
> by numerous other architectures. arm/blackfin/cris/ia64/m32r/m68knomm
> /microblaze/mn10300/sh/sparc all have pm_idle. This will keep spreading
> in future I guess.

Presumably because they've decided it is a good model and works for them.
That's a matter for their arch maintainers surely.

> https://lkml.org/lkml/2010/10/19/449 . The problem  is that it
> results in two places of registration: cpuidle subsystem and
> this. It was pointed that 99.99% of people run cpuidle and
> we should directly call cpuidle and use its registration mechanism
> rather than duplicate code.

That makes sense. However what Len is trying to do doesn't seem to.

The most likely case is nobody really needs APM idle now. In which case
Len's first patches (adding the warnings) make sense, but instead of
rushing headlong into everything else a simple years wait until the WARNs
have been in Fedora and co for a few months would avoid any further work
on it. In the mean time it produces a WARN, it can even be marked
__deprecated to ensure nobody else uses it.

The less likely case is that at some point within the year it turns out a
few people do need and care about it, so it needs shuffling into cpuidle
nicely.

In computing terms this seems to be a lazy evaluation problem - why do
all the extra work and risk bugs and problems trying to do things within
one release when you can just let it chill for a year and maybe not do
any work at all ?

Don't let me stop anyone actually doing the work but it seems to be
impatience before sanity ?

Alan
