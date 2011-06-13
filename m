Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1FMQdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:33:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64942 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1FMQda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:33:30 -0400
Date: Mon, 13 Jun 2011 12:31:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Xen-devel] [PATCH 1/2] xen: Add __attribute__((format(printf...
 where appropriate
Message-ID: <20110613163158.GA26322@dumpdata.com>
References: <17ffbd77627a21c05ab9e1a07b5207334291cf01.1307895293.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17ffbd77627a21c05ab9e1a07b5207334291cf01.1307895293.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4DF63BD1.003C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 09:21:13AM -0700, Joe Perches wrote:
> Use the compiler to verify printf formats and arguments.
> 

What compiler? If this is not included in 3.0 what is the fallout?

> Fix fallout.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/block/xen-blkback/xenbus.c |    2 +-
>  include/xen/hvc-console.h          |    4 +++-
>  include/xen/xenbus.h               |    2 ++
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 6cc0db1..3f129b4 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -684,7 +684,7 @@ again:
>  
>  	err = xenbus_switch_state(dev, XenbusStateConnected);
>  	if (err)
> -		xenbus_dev_fatal(dev, err, "switching to Connected state",
> +		xenbus_dev_fatal(dev, err, "%s: switching to Connected state",
>  				 dev->nodename);
>  
>  	return;
> diff --git a/include/xen/hvc-console.h b/include/xen/hvc-console.h
> index c3adde3..901724d 100644
> --- a/include/xen/hvc-console.h
> +++ b/include/xen/hvc-console.h
> @@ -6,11 +6,13 @@ extern struct console xenboot_console;
>  #ifdef CONFIG_HVC_XEN
>  void xen_console_resume(void);
>  void xen_raw_console_write(const char *str);
> +__attribute__((format(printf, 1, 2)))
>  void xen_raw_printk(const char *fmt, ...);
>  #else
>  static inline void xen_console_resume(void) { }
>  static inline void xen_raw_console_write(const char *str) { }
> -static inline void xen_raw_printk(const char *fmt, ...) { }
> +static inline __attribute__((format(printf, 1, 2)))
> +void xen_raw_printk(const char *fmt, ...) { }
>  #endif
>  
>  #endif	/* XEN_HVC_CONSOLE_H */
> diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
> index 5467369..aceeca7 100644
> --- a/include/xen/xenbus.h
> +++ b/include/xen/xenbus.h
> @@ -223,7 +223,9 @@ int xenbus_free_evtchn(struct xenbus_device *dev, int port);
>  
>  enum xenbus_state xenbus_read_driver_state(const char *path);
>  
> +__attribute__((format(printf, 3, 4)))
>  void xenbus_dev_error(struct xenbus_device *dev, int err, const char *fmt, ...);
> +__attribute__((format(printf, 3, 4)))
>  void xenbus_dev_fatal(struct xenbus_device *dev, int err, const char *fmt, ...);
>  
>  const char *xenbus_strstate(enum xenbus_state state);
> -- 
> 1.7.6.rc1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
