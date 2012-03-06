Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab2CFOOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:14:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758264Ab2CFOOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:14:30 -0500
Date: Tue, 6 Mar 2012 15:14:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>
Subject: Re: linux-next: build failure after merge of the final tree
 (moduleh/trivial trees related)
In-Reply-To: <20120306175844.9c97ac3bcc5579fba377fbd8@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1203061513530.23367@pobox.suse.cz>
References: <20120306175844.9c97ac3bcc5579fba377fbd8@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, Stephen Rothwell wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/power/max8998_charger.c:198:12: error: 'THIS_MODULE' undeclared here (not in a function)
> drivers/power/max8998_charger.c:207:20: error: expected declaration specifiers or '...' before string constant
> drivers/power/max8998_charger.c:208:15: error: expected declaration specifiers or '...' before string constant
> drivers/power/max8998_charger.c:209:16: error: expected declaration specifiers or '...' before string constant
> drivers/power/max8998_charger.c:210:14: error: expected declaration specifiers or '...' before string constant
> 
> Caused by commit 13ae246db4a0 ("includecheck: delete any duplicate
> instances of module.h") from the moduleh tree interacting with commit
> ce64b8d85de9 ("power, max8998: Include linux/module.h just once in
> drivers/power/max8998_charger.c") from the trivial tree.
> 
> They both removed different includes of module.h leaving none.
> 
> I have applied the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 6 Mar 2012 17:56:45 +1100
> Subject: [PATCH] power, max8998: we need at least one include of module.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/power/max8998_charger.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
> index d6a8c16..5c5f281 100644
> --- a/drivers/power/max8998_charger.c
> +++ b/drivers/power/max8998_charger.c
> @@ -19,6 +19,7 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>   */
>  
> +#include <linux/module.h>
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  #include <linux/platform_device.h>

I have dropped the patch from my tree, thanks for the report Stephen.

-- 
Jiri Kosina
SUSE Labs
