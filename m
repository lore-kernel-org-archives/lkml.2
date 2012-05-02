Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2ECO0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:26:38 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58741 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755939Ab2ECO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:26:03 -0400
Date: Wed, 2 May 2012 12:10:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf build-id: Fix filename size calculation
Message-ID: <20120502151005.GA5745@infradead.org>
References: <1335881976-3282-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335881976-3282-1-git-send-email-namhyung@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 01, 2012 at 11:19:36PM +0900, Namhyung Kim escreveu:
> The filename is a pointer variable so the sizeof(filename) will return
> length of a pointer. Fix it by using 'size'.

Applied.

The code worked because the snprintf buffer size parameter would always
be bigger (negative) than the sbuild_id lenght, and all fitted in the
filename allocated space. :-)

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  tools/perf/util/header.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 4c7c2d73251f..c0b70c697a36 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -296,7 +296,7 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
>  	if (mkdir_p(filename, 0755))
>  		goto out_free;
>  
> -	snprintf(filename + len, sizeof(filename) - len, "/%s", sbuild_id);
> +	snprintf(filename + len, size - len, "/%s", sbuild_id);
>  
>  	if (access(filename, F_OK)) {
>  		if (is_kallsyms) {
> -- 
> 1.7.9.2
