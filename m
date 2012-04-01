Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab2DAMT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 08:19:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36888 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2DAMTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 08:19:48 -0400
Date: Sun, 1 Apr 2012 14:19:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: semaphore and mutex in current Linux kernel (3.2.2)
Message-ID: <20120401121943.GA11893@gmail.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chen, Dennis (SRDC SW) <Dennis1.Chen@amd.com> wrote:

> Documentation/mutex-design.txt:
> 
> "- 'struct mutex' is smaller on most architectures: E.g. on x86,
>    'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
>    A smaller structure size means less RAM footprint, and better
>    CPU-cache utilization."
> ================================================================
>
> Now in my x86-64 32-bit Linux environment, 'struct semaphone' 
> is 16 bytes, 'struct mutex' is 20 bytes. So seems the RAM 
> footprint advantages are not there...

It got larger due to the adaptive spin-mutex performance 
optimization.

> For the performance advantages followed, I don't have the 
> ./test-mutex and maybe the testing environment, so haven't the 
> 1st hand data for this item...

Well, a way to reproduce that would be to find a lock_mutex 
intense workload ('perf top -g', etc.), and then changing back 
the underlying mutex to a semaphore, and measure the performance 
of the two primitives.

Thanks,

	Ingo
