Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2BFXxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:53:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2BFXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:53:47 -0500
Date: Mon, 6 Feb 2012 15:53:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, xiyou.wangcong@gmail.com,
        penberg@kernel.org, fengguang.wu@intel.com, cl@linux.com,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] move hugepage test examples to
 tools/testing/selftests/vm
Message-Id: <20120206155340.b9075240.akpm@linux-foundation.org>
In-Reply-To: <20120205081555.GA2249@darkstar.redhat.com>
References: <20120205081555.GA2249@darkstar.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Feb 2012 16:15:55 +0800
Dave Young <dyoung@redhat.com> wrote:

> hugepage-mmap.c, hugepage-shm.c and map_hugetlb.c in Documentation/vm are
> simple pass/fail tests, It's better to promote them to tools/testing/selftests
> 
> Thanks suggestion of Andrew Morton about this. They all need firstly setting up
> proper nr_hugepages and hugepage-mmap need to mount hugetlbfs. So I add a shell
> script run_test to do such work which will call the three test programs and
> check the return value of them.
> 
> Changes to original code including below:
> a. add run_test script
> b. return error when read_bytes mismatch with writed bytes.
> c. coding style fixes: do not use assignment in if condition
> 

I think Frederic is doing away with tools/testing/selftests/run_tests
in favour of a Makefile target?  ("make run_tests", for example).

Until we see such a patch we cannot finalise your patch and if I apply
your patch, his patch will need more work.  Not that this is rocket
science ;)

> 
> ...
>
> --- /dev/null
> +++ b/tools/testing/selftests/vm/run_test

(We now have a "run_tests" and a "run_test".  The difference in naming
is irritating)

Your vm/run_test file does quite a lot of work and we couldn't sensibly
move all its functionality into Makefile, I expect.

So I think it's OK to retain a script for this, but I do think that we
should think up a standardized way of invoking it from vm/Makefile, so
the top-level Makefile in tools/testing/selftests can simply do "cd
vm;make run_test", where the run_test target exists in all
subdirectories.  The vm/Makefile run_test target can then call out to
the script.

Also, please do not assume that the script has the x bit set.  The x
bit easily gets lost on kernel scripts (patch(1) can lose it) so it is
safer to invoke the script via "/bin/sh script-name" or $SHELL or
whatever.

Anyway, we should work with Frederic on sorting out some standard
behavior before we can finalize this work, please.

