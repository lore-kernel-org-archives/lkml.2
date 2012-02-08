Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2BHX6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:58:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52827 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2BHX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:58:00 -0500
Date: Thu, 9 Feb 2012 00:57:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xiyou.wangcong@gmail.com, penberg@kernel.org,
        fengguang.wu@intel.com, cl@linux.com
Subject: Re: [PATCH] selftests: Launch individual selftests from the main
 Makefile
Message-ID: <20120208235752.GE25473@somewhere.redhat.com>
References: <20120205081555.GA2249@darkstar.redhat.com>
 <20120206155340.b9075240.akpm@linux-foundation.org>
 <20120208034055.GA23894@somewhere.redhat.com>
 <20120208152022.1016434f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208152022.1016434f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 03:20:22PM -0800, Andrew Morton wrote:
> On Wed, 8 Feb 2012 04:40:59 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Drop the run_tests script and launch the selftests by calling
> > "make run_tests" from the selftests top directory instead. This
> > delegates to the Makefile on each selftest directory where it
> > is decided how to launch the local test.
> > 
> > This drops the need to add each selftest directory on the
> > now removed "run_tests" top script.
> 
> Looks good.
> 
> I did
> 
> 	cd tools/testing/selftests
> 	make run_tests
> 
> and it didn't work.  This?
> 
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: selftests/Makefile: make `run_tests' depend on `all'
> 
> So a "make run_tests" will build the tests before trying to run them.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  tools/testing/selftests/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN tools/testing/selftests/Makefile~a tools/testing/selftests/Makefile
> --- a/tools/testing/selftests/Makefile~a
> +++ a/tools/testing/selftests/Makefile
> @@ -5,7 +5,7 @@ all:
>  		make -C $$TARGET; \
>  	done;
>  
> -run_tests:
> +run_tests: all
>  	for TARGET in $(TARGETS); do \
>  		make -C $$TARGET run_tests; \
>  	done;

Yeah that's good. Thanks!
