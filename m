Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab1HXTmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 15:42:54 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:52893 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751194Ab1HXTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 15:42:50 -0400
Date: Wed, 24 Aug 2011 12:42:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jason Baron <jbaron@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Bart Van Assche <bvanassche@acm.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, greg@kroah.com
Subject: Re: linux-next: Tree for Aug 24 (dynamic_debug)
Message-Id: <20110824124248.13aa3ed4.rdunlap@xenotime.net>
In-Reply-To: <20110824193244.GA2540@redhat.com>
References: <20110824160404.ebad6370aee2cad82a990142@canb.auug.org.au>
	<20110824102551.8fc076b5.rdunlap@xenotime.net>
	<20110824193244.GA2540@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 15:32:45 -0400 Jason Baron wrote:

> On Wed, Aug 24, 2011 at 10:25:51AM -0700, Randy Dunlap wrote:
> > On Wed, 24 Aug 2011 16:04:04 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > 
> > When CONFIG_NET is not enabled (I see this on i386 builds):
> > 
> > lib/built-in.o: In function `__dynamic_netdev_dbg':
> > (.text+0x9fda): undefined reference to `__netdev_printk'
> > 
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> Ok, we probably want something, like below, although something keeps
> selecting CONFIG_NET, when I try to unset it, in my .config...so not yet
> tested, but should work.

Yes, that works.  Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>



> Thanks,
> 
> -Jason
> 
> 
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index ee3b9ba..e4760de 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -504,6 +504,8 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
>  }
>  EXPORT_SYMBOL(__dynamic_dev_dbg);
>  
> +#ifdef CONFIG_NET
> +
>  int __dynamic_netdev_dbg(struct _ddebug *descriptor,
>  		      const struct net_device *dev, const char *fmt, ...)
>  {
> @@ -528,6 +530,8 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
>  }
>  EXPORT_SYMBOL(__dynamic_netdev_dbg);
>  
> +#endif
> +
>  static __initdata char ddebug_setup_string[1024];
>  static __init int ddebug_setup_query(char *str)
>  {


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
