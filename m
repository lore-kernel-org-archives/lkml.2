Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab0HLWbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:31:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934058Ab0HLWbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:31:02 -0400
Date: Fri, 13 Aug 2010 00:28:43 +0200
From: Michal Marek <mmarek@suse.cz>
To: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: [PATCH] nconfig: Fix segfault when menu is empty
Message-ID: <20100812222843.GA19505@sepie.suse.cz>
References: <4C569703.9010607@udo.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C569703.9010607@udo.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 11:59:31AM +0200, Andrej Gelenberg wrote:
> there is a small bug in nconf, which cause segfault in empty menus
> (press right arrow in empty menu). Patch is attached.
> 
> Regards,
> Andrej Gelenberg

> From 60265c2f3db2616d3dc493785a47a301f73419bd Mon Sep 17 00:00:00 2001
> From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
> Date: Mon, 2 Aug 2010 11:41:36 +0200
> Subject: [PATCH] nconfig: Fix segfault when menu is empty
> 
> nconf crush with segfault if press right arrow in empty menu.
> 
> Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
> ---
>  scripts/kconfig/nconf.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> index 762caf8..3db3ca6 100644
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
> @@ -676,6 +676,7 @@ static void *item_data(void)
>  	struct mitem *mcur;
>  
>  	cur = current_item(curses_menu);
> +	if ( ! cur ) return NULL;
>  	mcur = (struct mitem *) item_userptr(cur);
>  	return mcur->usrptr;

Applied after fixing indentation (see Documentation/CodingStyle).

Michal
