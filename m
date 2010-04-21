Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0DTPyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:54:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:31839 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0DTPys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:54:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ppqAG2DjN7AMqa1VL96F32kkLMVUg8QyJ2zzKfXIqW+tZT5BOrkK+vfHWnnaVRxIR8
         mY3wK6s4FWmXEXO6TFnJaU87U2inod0fX8np6YkF2AXZIBtEQ1PKZXbSWtZo39/GnvEI
         jXpgfp/bbgWOIJk5husGvcaURbn6s4nzb+Prc=
Date: Wed, 21 Apr 2010 18:55:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Christian Kujau <lists@nerdbynature.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, schwab@linux-m68k.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Message-ID: <20100421155547.GA4222@x200>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
 <YeFfFNFyTSF.A.vUB.fSSzLB@tosh>
 <alpine.DEB.2.01.1004192339190.13016@bogon.housecafe.de>
 <1271765898.4324.2.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271765898.4324.2.camel@concordia>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 10:18:18PM +1000, Michael Ellerman wrote:
> On Mon, 2010-04-19 at 23:45 -0700, Christian Kujau wrote:
> --- a/fs/proc/proc_devtree.c
> +++ b/fs/proc/proc_devtree.c
> @@ -175,6 +175,24 @@ retry:
>         return fixed_name;
>  }
>  
> +static const char *unslash_name(const char *name)
> +{
> +       char *p, *fixed_name;
> +
> +       fixed_name = kstrdup(name);
> +       if (!fixed_name) {
> +               printk(KERN_ERR "device-tree: Out of memory trying to unslash "
> +                               "name \"%s\"\n", name);
> +               return name;
> +       }
> +
> +       p = fixed_name;
> +       while ((p = strstr(p, "/")))
> +               *p++ = '_';

This is wasteful. :-)
Also, I hope we won't spit message every time allocation fail.
