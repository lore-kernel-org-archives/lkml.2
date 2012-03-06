Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab2CFOOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:14:50 -0500
Received: from mail1.windriver.com ([147.11.146.13]:57209 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab2CFOOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:14:48 -0500
Message-ID: <4F561BA9.8020504@windriver.com>
Date: Tue, 6 Mar 2012 09:14:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jesper Juhl <jj@chaosbits.net>
Subject: Re: linux-next: build failure after merge of the final tree (moduleh/trivial
 trees related)
References: <20120306175844.9c97ac3bcc5579fba377fbd8@canb.auug.org.au>
In-Reply-To: <20120306175844.9c97ac3bcc5579fba377fbd8@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-06 01:58 AM, Stephen Rothwell wrote:
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

Hi Jiri,

Since we'll still have the global dup removal commit regardless,
it probably makes sense to just drop the one in trivial.  But if
that is a problem for one reason or another, let me know and I'll
fixup my commit to at least delete the same one you delete.

Thanks,
Paul.

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
