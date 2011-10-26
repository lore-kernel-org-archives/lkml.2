Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab1JZRBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:01:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55509 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953Ab1JZRBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:01:38 -0400
Date: Wed, 26 Oct 2011 15:01:33 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: furat.afram@gmail.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] perf probe:fix sigsegv in adding nonexistent event
Message-ID: <20111026170133.GD9467@ghostprotocols.net>
References: <1319600345-29311-1-git-send-email-furat.afram@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319600345-29311-1-git-send-email-furat.afram@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 25, 2011 at 08:39:05PM -0700, furat.afram@gmail.com escreveu:
> From: Furat Afram <furat.afram@gmail.com>
> 
> pref probe crashes when trying to add nonexistent event

Can you provide a backtrace of such crash? I'm having difficulty to
figure out how the patch provided will fix perf probe.

- Arnaldo
 
> Signed-off-by: Furat Afram <furat.afram@gmail.com>
> ---
>  tools/perf/util/symbol.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 40eeaf0..ad0c79b 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -636,14 +636,18 @@ static int dso__load_all_kallsyms(struct dso *dso, const char *filename,
>  static int dso__split_kallsyms(struct dso *dso, struct map *map,
>  			       symbol_filter_t filter)
>  {
> -	struct map_groups *kmaps = map__kmap(map)->kmaps;
> -	struct machine *machine = kmaps->machine;
> +	struct map_groups *kmaps;
> +	struct machine *machine;
>  	struct map *curr_map = map;
>  	struct symbol *pos;
>  	int count = 0, moved = 0;	
>  	struct rb_root *root = &dso->symbols[map->type];
>  	struct rb_node *next = rb_first(root);
>  	int kernel_range = 0;
> +	kmaps = map__kmap(map)->kmaps;
> +	if (kmaps == NULL)
> +		return -1;
> +	machine = kmaps->machine;
>  
>  	while (next) {
>  		char *module;
> -- 
> 1.7.6.4
