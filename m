Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1I1H5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:57:31 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:52323 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1I1H5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:57:30 -0400
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 28 Sep 2011 17:57:29 +1000
In-Reply-To: <CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
	 <CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com>
	 <1317194947.1998.18.camel@shrek.rexursive.com>
	 <CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317196649.1998.27.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:48 +0300, Pekka Enberg wrote:
> > We want to keep at least one CPU free for that I/O and for pulling
> the
> > other threads into sync when they are done (that is if we have more
> than
> > one), right?
> 
> Well, dunno if it matters much. Did you see performance improvement
> with that?

Haven't tried, to be honest. Just thought it may make sense.

> Is the CPU binding really needed?

Don't really know, but I would think it would help with
compression/decompression code. We don't want these threads bouncing
between CPUs unless they have to. I would guess the caches would work
better that way and all that.

Again, just guessing.

> Anyway, if you want to keep the existing behavior, maybe something
> like
> 
> nr_other_cpus = min(1, num_online_cpus()-1);
> 
> nr_threads = min(nr_other_cpus, LZO_THREADS);
> 
> would do the trick?

Yeah, makes sense. The first one should be max() though.

-- 
Bojan

