Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2CZQDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:03:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35090 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab2CZQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:03:06 -0400
Date: Mon, 26 Mar 2012 13:02:59 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] perf: Fix build error with -Werror in
 print_event_desc()
Message-ID: <20120326160259.GL25820@infradead.org>
References: <20120325.162828.1850698867642275016.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120325.162828.1850698867642275016.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Mar 25, 2012 at 04:28:28PM -0400, David Miller escreveu:
> 
> 'msz' should not be cast to ssize_t when comparing it to
> 'sz'.  'sz' is a u32 and thus unsigned, just like the type
> of 'msz' which is plain size_t.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  tools/perf/util/header.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

This one is already in perf/core:

commit 9fafd98f1bf14276f95b69f0186ad5675f1e1a18
Author: Jiri Olsa <jolsa@redhat.com>
Date:   Tue Mar 20 19:15:39 2012 +0100

    perf tools: Fix various casting issues for 32 bits
 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index fcd9cf3..4c7c2d7 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -1177,7 +1177,7 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
>  		goto error;
>  
>  	msz = sizeof(attr);
> -	if (sz < (ssize_t)msz)
> +	if (sz < msz)
>  		msz = sz;
>  
>  	for (i = 0 ; i < nre; i++) {
> -- 
> 1.7.9.1
