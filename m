Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284Ab2KXJp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 04:45:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64976 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030191Ab2KXJp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 04:45:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121124083137.625931698@redhat.com>
References: <20121124082918.671430919@redhat.com>
	<20121124083137.625931698@redhat.com>
Date: Sat, 24 Nov 2012 11:45:25 +0200
X-Google-Sender-Auth: izHTOSQLuRFEa4VGhABsQtht9pE
Message-ID: <CAOJsxLE8cYZOQe+y88X_AXKHO_NyeAXqBmq9OqRc+7Rb_sg_9A@mail.gmail.com>
Subject: Re: [patch 2/8] mqueue selftests: print failure status instead of
 cause make error
From: Pekka Enberg <penberg@kernel.org>
To: dyoung@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 10:29 AM,  <dyoung@redhat.com> wrote:
> Original behavior:
>   bash-4.1$ make -C mqueue run_tests
>   make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'
>   ./mq_open_tests /test1
>   Not running as root, but almost all tests require root in order to modify
>   system settings.  Exiting.
>   make: *** [run_tests] Error 1
>   make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'
>
> After applying the patch:
>   bash-4.1$ make -C mqueue run_tests
>   make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'
>   Not running as root, but almost all tests require root in order to modify
>   system settings.  Exiting.
>   mq_open_tests: [FAIL]
>   Not running as root, but almost all tests require root in order to modify
>   system settings.  Exiting.
>   mq_perf_tests: [FAIL]
>   make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'
>
> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  tools/testing/selftests/mqueue/Makefile |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- linux-2.6.orig/tools/testing/selftests/mqueue/Makefile      2012-11-23 22:37:04.945724010 +0800
> +++ linux-2.6/tools/testing/selftests/mqueue/Makefile   2012-11-23 22:38:43.101858919 +0800
> @@ -3,8 +3,8 @@ all:
>         gcc -O2 -lrt -lpthread -lpopt -o mq_perf_tests mq_perf_tests.c
>
>  run_tests:
> -       ./mq_open_tests /test1
> -       ./mq_perf_tests
> +       @./mq_open_tests /test1 || echo "mq_open_tests: [FAIL]"
> +       @./mq_perf_tests || echo "mq_perf_tests: [FAIL]"

Reviewed-by: Pekka Enberg <penberg@kernel.org>

I wonder though if we can make this more generic at higher level.
Maybe use Python or something instead of Makefiles for test case
definition?
