Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab2JPS3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:29:22 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:15139 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118Ab2JPS3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:29:21 -0400
Date: Tue, 16 Oct 2012 18:29:20 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Avleen Vig <avleen@gmail.com>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reading /proc/slabinfo causes stalls
In-Reply-To: <CAOJsxLF2VJRRu_i2aCARwiw6knyrwL1HpZ1zGOASP133fNxv8Q@mail.gmail.com>
Message-ID: <0000013a6ad64c95-106bab18-5a15-4c85-bae9-5527aa52f661-000000@email.amazonses.com>
References: <CAMjP1K=WV=AJ=paz7uBJ2X0FnOX6Cf-HipWsFjLxicXGbvL6Sw@mail.gmail.com> <CAOJsxLF2VJRRu_i2aCARwiw6knyrwL1HpZ1zGOASP133fNxv8Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Pekka Enberg wrote:

> > Is this a known condition? Are there work arounds or other ways to get the
> > slab allocation data which don't cause stalls?
>
> What kernel version are you using? What does your .config look like?

slabinfo access requires a mutex which will stall certain slab operations
(shrinking caches, retuning caches, cleaning caches in SLAB).

If the allocator is SLAB then I would think that this is a stall of
slabinfo mutex vs. slab clean operations (gets more frequent the more
processors are in the box).

If this is the case then using the SLUB allocator will fix the issue since
SLUB does not need to perform cache cleaning.

