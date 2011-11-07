Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1KGRNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:13:55 -0500
Received: from fbr04.mfg.siteprotect.com ([64.26.60.139]:58746 "EHLO
	fbr04.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab1KGRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:13:54 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 12:13:54 EST
Date: Mon, 7 Nov 2011 12:03:37 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
In-Reply-To: <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
Message-ID: <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
References: <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6AE34.2000907@redhat.com> <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
 <4EB6BAED.2030400@redhat.com> <4EB6BEFA.6000303@codemonkey.ws> <20111106183132.GA4500@thunk.org> <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com> <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com> <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Pekka Enberg wrote:

> I've never heard ABI incompatibility used as an argument for perf. Ingo?

Never overtly.  They're too clever for that.

In any case, as a primary developer of a library (PAPI) that uses the 
perf_events ABI I have to say that having perf in the kernel has been a 
*major* pain for us.

Unlike the perf developers, we *do* have to maintain backwards 
compatability.  And we have a lot of nasty code in PAPI to handle this.
Entirely because the perf_events ABI is not stable.  It's mostly stable, 
but there are enough regressions to be a pain.

It's problem enough that there's no way to know what version of the 
perf_event abi you are running against and we have to guess based on 
kernel version.  This gets "fun" because all of the vendors have 
backported seemingly random chunks of perf_event code to their older 
kernels.

And it often does seem as the perf developers don't care when something 
breaks in perf_events if it doesn't affect perf users.

For example, the new NMI watchdog severely breaks perf_event event 
allocation if you are using FORMAT_GROUP.  perf doesn't use this though, 
so none of the kernel developers seem to care.  And unless I can quickly 
come up with a patch as an outsider, a few kernel versions will go by and 
the kernel devs will declare "well it was broken so long, now we don't 
have to fix it".  Fun.

Vince
