Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab2AQBAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:00:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab2AQBAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:00:18 -0500
Date: Mon, 16 Jan 2012 16:59:44 -0800
From: Greg KH <gregkh@suse.de>
To: =?utf-8?B?7LWc7KKF7ZmY?= <jhbird.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>
Subject: Re: Re: [PATCH] driver-core: Fix null reference in
 subsys_interface_unregister
Message-ID: <20120117005944.GA14863@suse.de>
References: <15905052.41411326760535818.JavaMail.weblogic@epv6ml08>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15905052.41411326760535818.JavaMail.weblogic@epv6ml08>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 12:35:35AM +0000, 최종환 wrote:
> Greg KH wrote:
> 
> >On Sat, Jan 14, 2012 at 11:06:03AM +0900, jhbird.choi@samsung.com wrote:
> >> From: Jonghwan Choi 
> > >
> > >Check if the sif is not NULL before de-referencing it
> 
> >Why would it be?  Have you hit this somehow?  If so, in what code?
> 
> > thanks,
> 
> > greg k-h
> 
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 99dc592..4ddb38b 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -1193,13 +1193,15 @@ EXPORT_SYMBOL_GPL(subsys_interface_register);
> 
>  void subsys_interface_unregister(struct subsys_interface *sif)
>  {
> -       struct bus_type *subsys = sif->subsys;   // -> Sif is already used, that means sif is not null
> +       struct bus_type *subsys;
>         struct subsys_dev_iter iter;
>         struct device *dev;
> 
> -       if (!sif)  // -> Check whether sif is null 
> +       if (!sif || !sif->subsys)
>                 return;
> 
> +       subsys = sif->subsys;
> +
>         mutex_lock(&subsys->p->mutex);
>         list_del_init(&sif->node);
>         if (sif->remove_dev) {
> -- 
> 
> sif is already used, but  null pointer check for sif later.
> so i think that sif should be checked before use it.

Yes, you are right, I missed the previous usage.  I'll queue this up for
3.4.

thanks,

greg k-h
