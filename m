Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab0EQPeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:34:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:38073 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab0EQPeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:34:09 -0400
Date: Mon, 17 May 2010 08:24:26 -0700
From: Greg KH <gregkh@suse.de>
To: Christoph Egger <siccegge@cs.fau.de>, Mark McLoughlin <markmc@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Emese Revfy <re.emese@gmail.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] Typo in drivers/base/core.c
Message-ID: <20100517152426.GA27847@suse.de>
References: <20100517145757.GA3686@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517145757.GA3686@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 04:57:58PM +0200, Christoph Egger wrote:
> Hi all!
> 
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we are looking at multiple integrity errors in linux'
> configuration system.
> 
> 	There's a typo in linux' source (CONFIG_MODULE -- missing the
> final S) making the whole codeblock unselectable. The included patch
> should address this issue.

Heh, this has been there since the code went into the tree, way back in
2.6.29 (1 1/2 years ago).  Nice fine, I'll queue it up later this week.

Mark, how did you ever test this?

thanks,

greg k-h

> >From d5fe80140757fedfe19c293cd7af4c1030b92353 Mon Sep 17 00:00:00 2001
> From: Christoph Egger <siccegge@cs.fau.de>
> Date: Mon, 17 May 2010 16:48:59 +0200
> Subject: [PATCH] CONFIG_MODULES misstyped as _MODULE
> 
> In this code section the final S of CONFIG_MODULES was missed making
> the whole check useless
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  drivers/base/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index b56a0ba..f801c36 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1372,7 +1372,7 @@ struct device *__root_device_register(const char *name, struct module *owner)
>  		return ERR_PTR(err);
>  	}
>  
> -#ifdef CONFIG_MODULE	/* gotta find a "cleaner" way to do this */
> +#ifdef CONFIG_MODULES	/* gotta find a "cleaner" way to do this */
>  	if (owner) {
>  		struct module_kobject *mk = &owner->mkobj;
>  
> -- 
> 1.6.3.3
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
