Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab2ALUtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:49:22 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35657 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2ALUtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:49:21 -0500
MIME-Version: 1.0
In-Reply-To: <1326400778-24131-1-git-send-email-dumitru.sorin87@gmail.com>
References: <1326400778-24131-1-git-send-email-dumitru.sorin87@gmail.com>
Date: Thu, 12 Jan 2012 22:49:20 +0200
X-Google-Sender-Auth: tk4OUKuHnAFlkDtq3x7iPUXjef4
Message-ID: <CAEnQRZAHqS674-dukv2syKreC1KtttWLYnE7brzcjSeg6tz7eg@mail.gmail.com>
Subject: Re: [PATCH] perf: check if address is in range
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Sorin Dumitru <dumitru.sorin87@gmail.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 10:39 PM, Sorin Dumitru
<dumitru.sorin87@gmail.com> wrote:
> When addr isn't in the [sym->start,sym->end] range offset
> will be a very big value, giving us a segfault when we do:
>        h->addr[offset]++
> Fix this by checking that addr is in the correct range.
>
> Signed-off-by: Sorin Dumitru <dumitru.sorin87@gmail.com>
> ---
>  tools/perf/util/annotate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 011ed26..4ddc55f 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
>
>        pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
>
> -       if (addr >= sym->end)
> +       if (addr <= sym->start || addr >= sym->end)
>                return 0;

Shouldn't this be addr < sym->start ?

thanks,
Daniel.
