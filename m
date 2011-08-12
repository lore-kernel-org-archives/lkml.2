Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab1HLFRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 01:17:47 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:37353 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1HLFRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 01:17:46 -0400
Subject: Re: [PATCH] perf: fix temporary file ownership check
From: Pekka Enberg <penberg@kernel.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110811205537.GA22864@albatros>
References: <20110811205537.GA22864@albatros>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 12 Aug 2011 08:17:43 +0300
Message-ID: <1313126263.29737.21.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 00:55 +0400, Vasiliy Kulikov wrote:
> A file in /tmp/ might be a symlink, so lstat() should be used
> instead of stat().
> 
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Acked-by: Pekka Enberg <penberg@kernel.org>

> ---
>  tools/perf/util/symbol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index a8b5371..5db39f6 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1506,7 +1506,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>  	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
>  		struct stat st;
>  
> -		if (stat(dso->name, &st) < 0)
> +		if (lstat(dso->name, &st) < 0)
>  			return -1;
>  
>  		if (st.st_uid && (st.st_uid != geteuid())) {


