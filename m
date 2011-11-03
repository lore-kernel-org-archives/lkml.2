Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452Ab1KCTCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:02:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54337 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933886Ab1KCTCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:02:44 -0400
Date: Thu, 3 Nov 2011 19:03:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Max Kellermann <max@duempel.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111103190330.02590426@lxorguk.ukuu.org.uk>
In-Reply-To: <20111103185108.GA5153@Debian-60-squeeze-64-minimal>
References: <20111103162238.27609.11515.stgit@rabbit.intern.cm-ag>
	<4EB2C4A5.6000406@parallels.com>
	<20111103165903.GA4755@Debian-60-squeeze-64-minimal>
	<20111103182101.5037c1e5@lxorguk.ukuu.org.uk>
	<20111103185108.GA5153@Debian-60-squeeze-64-minimal>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Putting a reasonable limit on jobs that are expected to run only for a
> limited amount of time, with a limited amount of total resources.  For

fork is an almost irrelevant resource. Address space (ie memory), file
handles and the like are actual constrained resources.

I can't help thinking this is focussing on a completely irrelevant
cornercase issue. It belongs as part of a general resource limiting
cgroup that also deals with memory, I/O and the like. In fact most of
these resources are a balancing act.

Who cares if you have 10,000 threads. We can handle that without trying.
10,000 different mappings is a whole different ball game, and 100,000 file
handles in some configurations might also matter.

In short in your specific environment a fork runaway is a symptom you can
use to detect and sometimes halt the failure case. It's not the actual
resource problem and it doesn't solve the general case.

> Similar existing feature: RLIMIT_CPU.  Millions of users have it in
> their kernels, but nobody uses it nowadays.  And it's not even
> optional.

It's required by the standards, and basically unmeasurable overhead.

> Btw. I have no problem with maintaining this patch (and a whole bunch
> of others) in my proprietary git repository at work forever.  They're
> very useful for my employer.  I'm just trying to be a good citizen by
> sharing them.

Sure - I'm just not seeing that a whole separate cgroup for it is
appropriate or a good plan. Anyone doing real resource management needs
the rest of the stuff anyway.
