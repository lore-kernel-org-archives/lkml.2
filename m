Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab1ELUak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:30:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:46188 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642Ab1ELUai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:30:38 -0400
Message-ID: <4DCC4365.3030907@suse.cz>
Date: Thu, 12 May 2011 22:30:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: mfmooney@gmail.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [Resend PATCH] package: Makefile: fix perf target bug
References: <1d7d3b31c0da82ce8ce75778922155b7004a8f7e.1305224477.git.mfm@muteddisk.com>
In-Reply-To: <1d7d3b31c0da82ce8ce75778922155b7004a8f7e.1305224477.git.mfm@muteddisk.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.5.2011 20:25, mfmooney@gmail.com wrote:
> diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> index 1b7eaea..a32dc2d 100644
> --- a/scripts/package/Makefile
> +++ b/scripts/package/Makefile
> @@ -118,10 +118,14 @@ perf-tar=perf-$(KERNELVERSION)
>  
>  quiet_cmd_perf_tar = TAR
>        cmd_perf_tar = \
> -git archive --prefix=$(perf-tar)/ HEAD^{tree}                       \
> -	$$(cat $(srctree)/tools/perf/MANIFEST) -o $(perf-tar).tar;  \
> +git --git-dir=$(srctree)/.git --work-tree=$(srctree)                \

Neither git archive not git rev-parse need the work tree, --git-dir=..
is sufficient.

Michal

> +	archive --prefix=$(perf-tar)/ HEAD^{tree}                   \
> +	$(addprefix $(srctree)/,                                    \
> +	  $(shell cat $(srctree)/tools/perf/MANIFEST))              \
> +	-o $(perf-tar).tar;                                         \
>  mkdir -p $(perf-tar);                                               \
> -git rev-parse HEAD > $(perf-tar)/HEAD;                              \
> +git --git-dir=$(srctree)/.git --work-tree=$(srctree)                \
> +	rev-parse HEAD > $(perf-tar)/HEAD;                          \
>  tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \
>  rm -r $(perf-tar);                                                  \
>  $(if $(findstring tar-src,$@),,                                     \

