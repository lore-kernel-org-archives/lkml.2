Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0GEHQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 03:16:41 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:33024 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494Ab0GEHQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 03:16:39 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201007050712.o657CpjO028121@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH] compal-laptop/fujitsu-laptop/msi-laptop: make dmi_check_cb
To: axel.lin@gmail.com (Axel Lin)
Date: Mon, 5 Jul 2010 16:42:51 +0930 (CST)
Cc: linux-kernel@vger.kernel.org (linux-kernel),
       cezary.jackiewicz@gmail.com (Cezary Jackiewicz),
       mjg@redhat.com (Matthew Garrett),
       tim.gardner@canonical.com (Tim Gardner),
       Mario_Limonciello@Dell.com (Mario Limonciello),
       rpurdie@linux.intel.com (Richard Purdie), mmarek@suse.cz (Michal Marek),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       len.brown@intel.com (Len Brown),
       akpm@linux-foundation.org (Andrew Morton),
       stefani@seibold.net (Stefani Seibold), ak@linux.intel.com (Andi Kleen),
       mzxreary@0pointer.de (Lennart Poettering),
       jlee@novell.com (Lee Chun-Yi), platform-driver-x86@vger.kernel.org
In-Reply-To: <1278061453.15256.1.camel@mola> from "Axel Lin" at Jul 02, 2010 05:04:13 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there no possibility of some other matching function existing after ours
in the tree which might need to also be called?  If so, this change would
prevent that.

Regards
  jonathan

> dmi_check_system() walks the table running matching functions until someone
> returns non zero or we hit the end.
> 
> This patch makes dmi_check_cb to return 1 so dmi_check_system() return
> immediately when a match is found.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/compal-laptop.c  |    2 +-
>  drivers/platform/x86/fujitsu-laptop.c |    6 +++---
>  drivers/platform/x86/msi-laptop.c     |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
> index 71ff154..dc31a08 100644
> --- a/drivers/platform/x86/compal-laptop.c
> +++ b/drivers/platform/x86/compal-laptop.c
> @@ -190,7 +190,7 @@ static int dmi_check_cb(const struct dmi_system_id *id)
>  	printk(KERN_INFO "compal-laptop: Identified laptop model '%s'.\n",
>  		id->ident);
>  
> -	return 0;
> +	return 1;
>  }
>  
>  static struct dmi_system_id __initdata compal_dmi_table[] = {
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index dab1a0e..1859d7f 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -603,7 +603,7 @@ static int dmi_check_cb_s6410(const struct dmi_system_id *id)
>  	dmi_check_cb_common(id);
>  	fujitsu->keycode1 = KEY_SCREENLOCK;	/* "Lock" */
>  	fujitsu->keycode2 = KEY_HELP;	/* "Mobility Center" */
> -	return 0;
> +	return 1;
>  }
>  
>  static int dmi_check_cb_s6420(const struct dmi_system_id *id)
> @@ -611,7 +611,7 @@ static int dmi_check_cb_s6420(const struct dmi_system_id *id)
>  	dmi_check_cb_common(id);
>  	fujitsu->keycode1 = KEY_SCREENLOCK;	/* "Lock" */
>  	fujitsu->keycode2 = KEY_HELP;	/* "Mobility Center" */
> -	return 0;
> +	return 1;
>  }
>  
>  static int dmi_check_cb_p8010(const struct dmi_system_id *id)
> @@ -620,7 +620,7 @@ static int dmi_check_cb_p8010(const struct dmi_system_id *id)
>  	fujitsu->keycode1 = KEY_HELP;	/* "Support" */
>  	fujitsu->keycode3 = KEY_SWITCHVIDEOMODE;	/* "Presentation" */
>  	fujitsu->keycode4 = KEY_WWW;	/* "Internet" */
> -	return 0;
> +	return 1;
>  }
>  
>  static struct dmi_system_id fujitsu_dmi_table[] = {
> diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
> index afd762b..c67a74c 100644
> --- a/drivers/platform/x86/msi-laptop.c
> +++ b/drivers/platform/x86/msi-laptop.c
> @@ -434,7 +434,7 @@ static int dmi_check_cb(const struct dmi_system_id *id)
>  {
>  	printk(KERN_INFO "msi-laptop: Identified laptop model '%s'.\n",
>  	       id->ident);
> -	return 0;
> +	return 1;
>  }
>  
>  static struct dmi_system_id __initdata msi_dmi_table[] = {
> -- 
> 1.5.4.3
> 
> 
> 


-- 
* Jonathan Woithe    jwoithe@physics.adelaide.edu.au                        *
*                    http://www.physics.adelaide.edu.au/~jwoithe            *
***-----------------------------------------------------------------------***
** "Time is an illusion; lunchtime doubly so"                              **
*  "...you wouldn't recognize a subtle plan if it painted itself purple and *
*   danced naked on a harpsichord singing 'subtle plans are here again'"    *
