Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968310Ab2ESDb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 23:31:59 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:58527 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965245Ab2ESDb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 23:31:57 -0400
Date: Sat, 19 May 2012 07:31:54 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org, GregKH <greg@kroah.com>
Subject: Re: [PATCH] drivers/w1: cleanup w1_uevent
Message-ID: <20120519033154.GA12188@ioremap.net>
References: <1337330963-20485-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337330963-20485-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, May 18, 2012 at 02:19:23PM +0530, Devendra Naga (devendra.aaru@gmail.com) wrote:
> There were some return statements around in the w1_uevent, used goto
> to cleanup those return statements with the help of err variable,
> and also removed a semi colon at the end of the w1_uevent's closing
> brace.

I personally do not see whether this is better than what was before
So, Greg, it is up to you to decide :)

If you pull it in, then feel free to add my acked-by.
Thank you.

> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/w1/w1.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
> index 9761950..a0d3c59 100644
> --- a/drivers/w1/w1.c
> +++ b/drivers/w1/w1.c
> @@ -557,7 +557,7 @@ static int w1_uevent(struct device *dev, struct kobj_uevent_env *env)
>  	struct w1_master *md = NULL;
>  	struct w1_slave *sl = NULL;
>  	char *event_owner, *name;
> -	int err;
> +	int err = 0;
>  
>  	if (dev->driver == &w1_master_driver) {
>  		md = container_of(dev, struct w1_master, dev);
> @@ -576,19 +576,17 @@ static int w1_uevent(struct device *dev, struct kobj_uevent_env *env)
>  			event_owner, name, dev_name(dev));
>  
>  	if (dev->driver != &w1_slave_driver || !sl)
> -		return 0;
> +		goto end;
>  
>  	err = add_uevent_var(env, "W1_FID=%02X", sl->reg_num.family);
>  	if (err)
> -		return err;
> +		goto end;
>  
>  	err = add_uevent_var(env, "W1_SLAVE_ID=%024LX",
>  			     (unsigned long long)sl->reg_num.id);
> -	if (err)
> -		return err;
> -
> -	return 0;
> -};
> +end:
> +	return err;
> +}
>  #else
>  static int w1_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
> -- 
> 1.7.9.5

-- 
	Evgeniy Polyakov
