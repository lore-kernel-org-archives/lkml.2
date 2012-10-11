Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2JKUKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:10:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37973 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2JKUKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:10:20 -0400
MIME-Version: 1.0
Message-ID: <1a20296e-60c2-4b03-b322-5ac060b38b52@default>
Date: Thu, 11 Oct 2012 13:10:02 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: RE: [PATCH -next] staging: ramster: depends on NET
References: <20121011140604.f5093233badade406c3d06f7@canb.auug.org.au>
 <5076F503.3070808@xenotime.net>
In-Reply-To: <5076F503.3070808@xenotime.net>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> Sent: Thursday, October 11, 2012 10:34 AM
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Dan Magenheimer; Konrad Wilk; Greg
> Kroah-Hartman; devel@driverdev.osuosl.org
> Subject: [PATCH -next] staging: ramster: depends on NET
> 
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> ramster uses network interfaces that are only present when
> CONFIG_NET is enabled, so it should depend on NET.

Yep, thanks for catching!

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
 
> Fixes these build errors:
> 
> drivers/built-in.o: In function `sc_kref_release':
> tcp.c:(.text+0x24b9af): undefined reference to `sock_release'
> drivers/built-in.o: In function `r2net_open_listening_sock':
> tcp.c:(.text+0x24ca2b): undefined reference to `sock_create'
> tcp.c:(.text+0x24cb91): undefined reference to `sock_release'
> drivers/built-in.o: In function `r2net_recv_tcp_msg':
> tcp.c:(.text+0x24cdbd): undefined reference to `sock_recvmsg'
> drivers/built-in.o: In function `r2net_send_tcp_msg':
> tcp.c:(.text+0x24d341): undefined reference to `sock_sendmsg'
> drivers/built-in.o: In function `r2net_start_connect':
> tcp.c:(.text+0x24d8fa): undefined reference to `sock_create'
> drivers/built-in.o: In function `r2net_shutdown_sc':
> tcp.c:(.text+0x24e30c): undefined reference to `kernel_sock_shutdown'
> drivers/built-in.o: In function `r2net_accept_one':
> tcp.c:(.text+0x24f392): undefined reference to `sock_create_lite'
> tcp.c:(.text+0x24f3c3): undefined reference to `sock_release'
> drivers/built-in.o: In function `r2net_stop_listening':
> (.text+0x250f63): undefined reference to `sock_release'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: dan.magenheimer@oracle.com
> Cc: konrad.wilk@oracle.com
> ---
>  drivers/staging/ramster/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20121011.orig/drivers/staging/ramster/Kconfig
> +++ linux-next-20121011/drivers/staging/ramster/Kconfig
> @@ -18,6 +18,7 @@ config ZCACHE2
>  config RAMSTER
>  	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
>  	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE2=y
> +	depends on NET
>  	# must ensure struct page is 8-byte aligned
>  	select HAVE_ALIGNED_STRUCT_PAGE if !64_BIT
>  	default n
