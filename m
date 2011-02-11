Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab1BKCBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 21:01:42 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44123 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097Ab1BKCBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 21:01:41 -0500
Date: Thu, 10 Feb 2011 18:01:38 -0800
From: Andres Salomon <dilinger@queued.net>
To: cjb@laptop.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org, dsd@laptop.org
Subject: Re: [PATCH 06/10] olpc_dcon: add config options for XO_1 and
 XO_1_5, drop hardcoded XO-1 stuff
Message-ID: <20110210180138.6c7af1ef@queued.net>
In-Reply-To: <20110210175324.6d40a5ca@queued.net>
References: <20110210175324.6d40a5ca@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note one subtlety of this patch that I should've mentioned - due to
the Makefile maneuvering, the module has been renamed from olpc_dcon.ko
to olpc-dcon.ko.  For things like modprobe and /etc/modules, this
doesn't make a difference.  But, it might affect the OLPC'ers.


On Thu, 10 Feb 2011 17:53:24 -0800
Andres Salomon <dilinger@queued.net> wrote:

> 
> This adds CONFIG_FB_OLPC_DCON_1 and CONFIG_FB_OLPC_DCON_1_5 options
> for allowing selection of XO-1 and/or XO-1.5 DCON support.  In the
> process, it also forces the xo_1.c and xo_1_5.c files to build as
> separate units, correctly selects between XO-1 and XO-1.5 at runtime,
> and adds some hacks to allow xo_1_5.c to build.
> 
> This isn't the cleanest patch, but it'll get better as more global
> variables are dropped.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
[...]
> diff --git a/drivers/staging/olpc_dcon/Makefile
> b/drivers/staging/olpc_dcon/Makefile index cd8f289..36c7e67 100644
> --- a/drivers/staging/olpc_dcon/Makefile
> +++ b/drivers/staging/olpc_dcon/Makefile
> @@ -1 +1,6 @@
> -obj-$(CONFIG_FB_OLPC_DCON)	+= olpc_dcon.o
> +olpc-dcon-objs += olpc_dcon.o
> +olpc-dcon-$(CONFIG_FB_OLPC_DCON_1)	+= olpc_dcon_xo_1.o
> +olpc-dcon-$(CONFIG_FB_OLPC_DCON_1_5)	+= olpc_dcon_xo_1_5.o
> +obj-$(CONFIG_FB_OLPC_DCON)	+= olpc-dcon.o
[...]
