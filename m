Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2IXQCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:02:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab2IXQCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:02:10 -0400
Date: Mon, 24 Sep 2012 13:01:51 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] perf header: Add check_perf_magic() func
Message-ID: <20120924160151.GC9977@infradead.org>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
 <1348500251-9937-8-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348500251-9937-8-git-send-email-feng.tang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 24, 2012 at 11:24:09PM +0800, Feng Tang escreveu:
> With this func, other modules can basically check whether a file
> is a legal perf data file by checking its first 8 bytes aginst
> all possible perf magic nunbers.

Please consider submitting a patch to http://www.darwinsys.com/file/ :-)

- Arnaldo
 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  tools/perf/util/header.c |   11 +++++++++++
>  tools/perf/util/header.h |    1 +
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index ad72b28..555cb68 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -2174,6 +2174,17 @@ static int try_all_pipe_abis(uint64_t hdr_sz, struct perf_header *ph)
>  	return -1;
>  }
>  
> +/* Return 0 if matched */
> +int check_perf_magic(u64 magic)
> +{
> +	if (!memcmp(&magic, __perf_magic1, sizeof(magic))
> +		|| magic == __perf_magic2
> +		|| magic == __perf_magic2_sw)
> +		return 0;
> +
> +	return -1;
> +}
> +
>  static int check_magic_endian(u64 magic, uint64_t hdr_sz,
>  			      bool is_pipe, struct perf_header *ph)
>  {
> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
> index 58de08b..af1a51c 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -131,6 +131,7 @@ int perf_event__synthesize_build_id(struct perf_tool *tool,
>  int perf_event__process_build_id(struct perf_tool *tool,
>  				 union perf_event *event,
>  				 struct perf_session *session);
> +int check_perf_magic(u64 magic);
>  
>  /*
>   * arch specific callback
> -- 
> 1.7.1
