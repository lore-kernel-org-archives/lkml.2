Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030235Ab2KXJmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 04:42:38 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58990 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2KXJmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 04:42:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121124083138.648113811@redhat.com>
References: <20121124082918.671430919@redhat.com>
	<20121124083138.648113811@redhat.com>
Date: Sat, 24 Nov 2012 11:42:35 +0200
X-Google-Sender-Auth: znUTWgSj31NUaO4Linv-J3hWc5Q
Message-ID: <CAOJsxLFxhDYPmqy2s8WYtpPbhAqB3nAzFoyEGwmypfUC54ju-Q@mail.gmail.com>
Subject: Re: [patch 4/8] mem-hotplug selftests: print failure status instead
 of cause make error
From: Pekka Enberg <penberg@kernel.org>
To: dyoung@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 10:29 AM,  <dyoung@redhat.com> wrote:
>   bash-4.1$ make -C memory-hotplug run_tests
>   make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'
>   ./on-off-test.sh
>   make: execvp: ./on-off-test.sh: Permission denied
>   make: *** [run_tests] Error 127
>   make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'
>
> After applying the patch:
>   bash-4.1$ make -C memory-hotplug run_tests
>   make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'
>   /bin/sh: ./on-off-test.sh: Permission denied
>   memory-hotplug selftests: [FAIL]
>   make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'
>
> Signed-off-by: Dave Young <dyoung@redhat.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

It'd be good if we could turn off the make produced noise to make the
output look something like this:

   bash-4.1$ make -C memory-hotplug run_tests
   /bin/sh: ./on-off-test.sh: Permission denied
   memory-hotplug selftests: [FAIL]

> ---
>  tools/testing/selftests/memory-hotplug/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.orig/tools/testing/selftests/memory-hotplug/Makefile      2012-11-23 22:37:04.869057759 +0800
> +++ linux-2.6/tools/testing/selftests/memory-hotplug/Makefile   2012-11-23 22:38:43.148525333 +0800
> @@ -1,6 +1,6 @@
>  all:
>
>  run_tests:
> -       ./on-off-test.sh
> +       @./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
>
>  clean:
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
