Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2JWOMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:12:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab2JWOMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:12:30 -0400
Date: Tue, 23 Oct 2012 16:12:19 +0200
From: Andrew Jones <drjones@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf header: Fix numa topology printing
Message-ID: <20121023141218.GD2772@turtle.usersys.redhat.com>
References: <20121023072702.GB2772@turtle.usersys.redhat.com>
 <1350999890-6920-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350999890-6920-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:44:49PM +0900, Namhyung Kim wrote:
> Andrew reported that the commit 7e94cfcc9d20 ("perf header: Use pre-
> processed session env when printing") regresses the header output.
> It was because of a missed string pointer calculation in the loop.
> 
> Reported-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/header.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 7daad237dea5..566b84c695c8 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -1378,6 +1378,8 @@ static void print_numa_topology(struct perf_header *ph, int fd __maybe_unused,
>  
>  		str = tmp + 1;
>  		fprintf(fp, "# node%u cpu list : %s\n", c, str);
> +
> +		str += strlen(str) + 1;
>  	}
>  	return;
>  error:
> -- 
> 1.7.9.2
>

works for me

Tested-by: Andrew Jones <drjones@redhat.com> 
