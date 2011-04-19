Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1DSIsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:48:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:60290 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab1DSIs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:48:28 -0400
Date: Tue, 19 Apr 2011 10:48:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Alan Ott <alan@signal11.us>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH -next] hid-example: fix some build issues
In-Reply-To: <20110418111251.8a922b6b.randy.dunlap@oracle.com>
Message-ID: <alpine.LNX.2.00.1104191047090.12035@pobox.suse.cz>
References: <201104142149.p3ELnnoF008424@imap1.linux-foundation.org> <20110418111251.8a922b6b.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding Michal Marek to CC ]

On Mon, 18 Apr 2011, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> samples/hid-example.o needs some Kconfig and Makefile additions
> in order to build.  It should use <linux/*.h> headers from
> the build tree, so use HEADERS_CHECK to require that those
> header files be present.
> 
> Change the kconfig symbol from tristate to bool since
> userspace cannot be built as loadable modules.
> 
> However, I don't understand why the userspace header files are
> not present as reported in Andrew's build log, since it builds
> OK on x86_64 without any of these changes.

Yes, I have no idea how the build failure Andrew is reporting happens. 
Andrew -- what exact command are you using that leads to that failure?

Thanks.

> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Alan Ott <alan@signal11.us>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: linux-input@vger.kernel.org
> ---
>  samples/Kconfig         |    4 ++--
>  samples/hidraw/Makefile |    2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> --- linux-next-20110418.orig/samples/hidraw/Makefile
> +++ linux-next-20110418/samples/hidraw/Makefile
> @@ -6,3 +6,5 @@ hostprogs-y := hid-example
>  
>  # Tell kbuild to always build the programs
>  always := $(hostprogs-y)
> +
> +HOSTCFLAGS_hid-example.o += -I$(objtree)/usr/include
> --- linux-next-20110418.orig/samples/Kconfig
> +++ linux-next-20110418/samples/Kconfig
> @@ -62,8 +62,8 @@ config SAMPLE_KDB
>  	  command to the kdb shell.
>  
>  config SAMPLE_HIDRAW
> -	tristate "Build simple hidraw example"
> -	depends on HIDRAW
> +	bool "Build simple hidraw example"
> +	depends on HIDRAW && HEADERS_CHECK
>  	help
>  	  Build an example of how to use hidraw from userspace.
>  
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
