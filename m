Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab2LOS0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 13:26:10 -0500
Received: from popelka.ms.mff.cuni.cz ([195.113.20.131]:45576 "EHLO
	popelka.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2LOS0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 13:26:09 -0500
Date: Sat, 15 Dec 2012 20:15:49 +0100
From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
To: Stephan Mueller <smueller@chronox.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        lkml <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
Message-ID: <20121215191549.GA11036@domone.kolej.mff.cuni.cz>
References: <50C72800.20508@chronox.de>
 <20121212164321.a01c5641.akpm@linux-foundation.org>
 <50C98764.6050104@chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C98764.6050104@chronox.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why not use nonblocking pool and seed nonblocking pool only with half of
collected entropy to get /dev/random in almost all practical scenarios
nonblocking?

On Thu, Dec 13, 2012 at 08:44:36AM +0100, Stephan Mueller wrote:
> On 13.12.2012 01:43:21, +0100, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> 
> Hi Andrew,
> > On Tue, 11 Dec 2012 13:33:04 +0100
> > Stephan Mueller <smueller@chronox.de> wrote:
> >
> >> Some time ago, I noticed the fact that for every newly
> >> executed process, the function create_elf_tables requests 16 bytes of
> >> randomness from get_random_bytes. This is easily visible when calling
> >>
> >> while [ 1 ]
> >> do
> >> 	cat /proc/sys/kernel/random/entropy_avail
> >> 	sleep 1
> >> done
> > Please see
> > http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
> >
> > That patch is about one week from a mainline merge, btw.
> 
> Initially I was also thinking about get_random_int. But stack protection
> depends on non-predictable numbers to ensure it cannot be defeated. As
> get_random_int depends on MD5 which is assumed to be broken now, I
> discarded the idea of using get_random_int.
> 
> Moreover, please consider that get_cycles is an architecture-specific
> function that on some architectures only returns 0 (For all
> architectures where this is implemented, you have no guarantee that it
> increments as a high-resolution timer). So, the quality of
> get_random_int is questionable IMHO for the use as a stack protector.
> 
> Also note, that other in-kernel users of get_random_bytes may be
> converted to using the proposed kernel pool to avoid more entropy drainage.
> 
> Please note that the suggested approach of fully seeding a deterministic
> RNG never followed by a re-seeding is used elsewhere (e.g. the OpenSSL
> RNG). Therefore, I think the suggested approach is viable.
> 
> Ciao
> Stephan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 

It's those computer people in X {city of world}.  They keep stuffing things up.
