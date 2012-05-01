Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab2EATxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:53:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab2EATxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:53:47 -0400
Date: Tue, 1 May 2012 12:53:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [Patch 4/4] tools/selftests: add mq_perf_tests
Message-Id: <20120501125345.a3ac48c9.akpm@linux-foundation.org>
In-Reply-To: <674e3954fdc921d2ef34be5686092da4d5302e54.1335894230.git.dledford@redhat.com>
References: <1335894655-11398-1-git-send-email-dledford@redhat.com>
	<674e3954fdc921d2ef34be5686092da4d5302e54.1335894230.git.dledford@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 May 2012 13:50:55 -0400
Doug Ledford <dledford@redhat.com> wrote:

> Add the mq_perf_tests tool I used when creating my mq performance patch.
> Also add a local .gitignore to keep the binaries from showing up in
> git status output.
> 

hm, this code sends checkpatch berzerk.  I do think that selftests code
should match regular kernel coding - after all, kernel developers are
the ones who will be reading and modifying the code.

> diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing/selftests/mqueue/mq_perf_tests.c

hm, I didn't have <popt.h>.  On RH that's the popt-devel RPM.  On this
Ubuntu(ish) machine it's libpopt-dev.

On an x86_64 build I get these:

mq_open_tests.c: In function 'main':
mq_open_tests.c:295: warning: format '%d' expects type 'int', but argument 2 has type 'rlim_t'
mq_open_tests.c:296: warning: format '%d' expects type 'int', but argument 2 has type 'rlim_t'
mq_open_tests.c:311: warning: format '%d' expects type 'int', but argument 2 has type 'rlim_t'
mq_open_tests.c:312: warning: format '%d' expects type 'int', but argument 2 has type 'rlim_t'
gcc -O2 -lrt -lpthread -lpopt -o mq_perf_tests mq_perf_tests.c
mq_perf_tests.c: In function 'open_queue':
mq_perf_tests.c:299: warning: format '%d' expects type 'int', but argument 2 has type 'long int'
mq_perf_tests.c:300: warning: format '%d' expects type 'int', but argument 2 has type 'long int'
mq_perf_tests.c:301: warning: format '%d' expects type 'int', but argument 2 has type 'long int'
mq_perf_tests.c: In function 'perf_test_thread':
mq_perf_tests.c:441: warning: format '%d' expects type 'int', but argument 2 has type 'long int'
mq_perf_tests.c:456: warning: format '%d' expects type 'int', but argument 2 has type '__time_t'
mq_perf_tests.c:456: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mq_perf_tests.c:459: warning: format '%d' expects type 'int', but argument 2 has type 'long long unsigned int'
mq_perf_tests.c:461: warning: format '%d' expects type 'int', but argument 2 has type '__time_t'
mq_perf_tests.c:461: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mq_perf_tests.c:464: warning: format '%d' expects type 'int', but argument 2 has type 'long long unsigned int'
mq_perf_tests.c:468: warning: format not a string literal and no format arguments
mq_perf_tests.c:495: warning: format '%d' expects type 'int', but argument 2 has type '__time_t'
mq_perf_tests.c:495: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mq_perf_tests.c:498: warning: format '%d' expects type 'int', but argument 2 has type 'long long unsigned int'
mq_perf_tests.c:500: warning: format '%d' expects type 'int', but argument 2 has type '__time_t'
mq_perf_tests.c:500: warning: format '%d' expects type 'int', but argument 3 has type 'long int'
mq_perf_tests.c:503: warning: format '%d' expects type 'int', but argument 2 has type 'long long unsigned int'
mq_perf_tests.c: In function 'main':
mq_perf_tests.c:651: warning: format '%d' expects type 'int', but argument 2 has type 'rlim_t'
mq_perf_tests.c:652: warning: format '%d' expects type 'int', but argument 2 has type 'rlim_t'
mq_perf_tests.c:666: warning: format '%d' expects type 'int', but argument 2 has type 'rlim_t'
mq_perf_tests.c:668: warning: format '%d' expects type 'int', but argument 2 has type 'rlim_t'

I assume part of it is this:

/usr/include/bits/resource.h:typedef __rlim64_t rlim_t;

But I didn't look into the others.  I can do so?
