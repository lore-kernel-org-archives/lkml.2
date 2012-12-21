Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2LUTh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 14:37:29 -0500
Received: from popelka.ms.mff.cuni.cz ([195.113.20.131]:40229 "EHLO
	popelka.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LUTh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 14:37:26 -0500
Date: Fri, 21 Dec 2012 20:32:27 +0100
From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        lkml <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
Message-ID: <20121221193226.GA5867@domone>
References: <50C72800.20508@chronox.de>
 <20121212164321.a01c5641.akpm@linux-foundation.org>
 <50C98764.6050104@chronox.de>
 <20121215191549.GA11036@domone.kolej.mff.cuni.cz>
 <50CD00E2.5050104@chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50CD00E2.5050104@chronox.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 11:59:46PM +0100, Stephan Müller wrote:
> Am 15.12.2012 20:15, schrieb Ondřej Bílka:
> >Why not use nonblocking pool and seed nonblocking pool only with half of
> >collected entropy to get /dev/random in almost all practical scenarios
> >nonblocking?
> 
> I would not recommend changing /dev/urandom. First, we would change
> the characteristic of a kernel interface a lot of user space
> cryptographic components rely on. 
How it would change characteristic more than swapping a hard disk for a
ssd? Should we display a message "Please type more slowly to maintain
kernel interface."?

> According to Linus that is
> typically a no-go. Moreover, the question can be raised, where do we
> pick the number of 50%, why not 30% or 70%, why (re)seeding it at
> all?
And does this argument make any difference?
> 
> Also, let us assume we pick 50% and we leave the create_elf_tables
> function as is (i.e. it pulls from get_random_bytes), I fear that we
> do not win at all. Our discussed problem is the depletion of the
> entropy via nonblocking_pool due to every execve() syscall requires
> 128 bits of data from nonblocking_pool. Even if we seed
> nonblocking_pool more rarely, we still deplete the entropy of the
> input_pool and thus deplete the entropy we want for cryptographic
> purposes a particular user has.
This is only correct upto thus part. As blocking pool would get full
after 8096 bytes would be generated, stayed full until needed and won't 
be affected by input pool. As long as we would generate at least twice
entropy than blocking pool consumes we would be fine.

