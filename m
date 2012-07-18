Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab2GRECZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:02:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49440 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2GRECN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:02:13 -0400
Date: Tue, 17 Jul 2012 21:00:09 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 04/17] pda_power: remove IRQF_SAMPLE_RANDOM which is now
 a no-op
Message-ID: <20120718040008.GA22599@lizard>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
 <1342560756-18737-5-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1342560756-18737-5-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 05:32:23PM -0400, Theodore Ts'o wrote:
> With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
> no-op; interrupt randomness is now collected unconditionally in a very
> low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
> flag was scheduled to be removed in 2009 on the
> feature-removal-schedule, so this patch is preparation for the final
> removal of this flag.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---

Applied, thanks!

>  drivers/power/pda_power.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> index 214468f..db5c526 100644
> --- a/drivers/power/pda_power.c
> +++ b/drivers/power/pda_power.c
> @@ -24,11 +24,7 @@
>  
>  static inline unsigned int get_irq_flags(struct resource *res)
>  {
> -	unsigned int flags = IRQF_SAMPLE_RANDOM | IRQF_SHARED;
> -
> -	flags |= res->flags & IRQF_TRIGGER_MASK;
> -
> -	return flags;
> +	return IRQF_SHARED | (res->flags & IRQF_TRIGGER_MASK);
>  }
>  
>  static struct device *dev;

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
