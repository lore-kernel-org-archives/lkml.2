Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2BHXUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:20:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2BHXUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:20:23 -0500
Date: Wed, 8 Feb 2012 15:20:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xiyou.wangcong@gmail.com, penberg@kernel.org,
        fengguang.wu@intel.com, cl@linux.com
Subject: Re: [PATCH] selftests: Launch individual selftests from the main
 Makefile
Message-Id: <20120208152022.1016434f.akpm@linux-foundation.org>
In-Reply-To: <20120208034055.GA23894@somewhere.redhat.com>
References: <20120205081555.GA2249@darkstar.redhat.com>
	<20120206155340.b9075240.akpm@linux-foundation.org>
	<20120208034055.GA23894@somewhere.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012 04:40:59 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Drop the run_tests script and launch the selftests by calling
> "make run_tests" from the selftests top directory instead. This
> delegates to the Makefile on each selftest directory where it
> is decided how to launch the local test.
> 
> This drops the need to add each selftest directory on the
> now removed "run_tests" top script.

Looks good.

I did

	cd tools/testing/selftests
	make run_tests

and it didn't work.  This?



From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/Makefile: make `run_tests' depend on `all'

So a "make run_tests" will build the tests before trying to run them.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/Makefile~a tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~a
+++ a/tools/testing/selftests/Makefile
@@ -5,7 +5,7 @@ all:
 		make -C $$TARGET; \
 	done;
 
-run_tests:
+run_tests: all
 	for TARGET in $(TARGETS); do \
 		make -C $$TARGET run_tests; \
 	done;
_

