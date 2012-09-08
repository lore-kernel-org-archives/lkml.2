Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2IHJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 05:09:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49581 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2IHJJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 05:09:56 -0400
MIME-Version: 1.0
In-Reply-To: <1347065004-15306-6-git-send-email-irina.tirdea@intel.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
	<1347065004-15306-6-git-send-email-irina.tirdea@intel.com>
Date: Sat, 8 Sep 2012 12:09:54 +0300
X-Google-Sender-Auth: bdkLDb1BVilKZgyH1IOifge4JC0
Message-ID: <CAOJsxLH_8h=GDaC=5MzjiFT1rfN5CHKpPX3PKDDHGubQpV1zuQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] perf tools: include basename for non-glibc systems
From: Pekka Enberg <penberg@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, paulus@samba.org, dsahern@gmail.com,
        namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 8, 2012 at 3:43 AM, Irina Tirdea <irina.tirdea@gmail.com> wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
>
> perf uses the glibc version of basename(), by defining _GNU_SOURCE, including
> string.h and not including libgen.h. The glibc version of basename is better
> than the POSIX version since it does not modify its argument.
>
> Android has only one version of basename which is defined in libgen.h.
> This version is the same as the glibc version.
>
> Error on Android:
> util/annotate.c: In function 'symbol__annotate_printf':
> util/annotate.c:503:3: error: implicit declaration of function 'basename'
> [-Werror=implicit-function-declaration]
> util/annotate.c:503:3: error: nested extern declaration of 'basename'
> [-Werror=nested-externs]
> util/annotate.c:503:14: error: assignment makes pointer from integer without
> a cast [-Werror]
>
> On Android libgen.h should be included to define basename.
>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  tools/perf/util/symbol.h |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index fc4b1e6..d3b330c 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -10,6 +10,9 @@
>  #include <linux/rbtree.h>
>  #include <stdio.h>
>  #include <byteswap.h>
> +#if defined(__BIONIC__)
> +#include <libgen.h>
> +#endif

It's safe to include <libgen.h> on glibc Linux systems as well, no? So
there's no need to check for __BIONIC__.
