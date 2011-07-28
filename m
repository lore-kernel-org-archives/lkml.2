Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1G1UTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:19:37 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:38272 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab1G1UTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:19:34 -0400
Subject: Re: [PATCH -next] target: iscsi_target depends on NET
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        target-devel@vger.kernel.org
In-Reply-To: <20110728094819.22e19fe9.rdunlap@xenotime.net>
References: <20110728135707.44ae2d79ecdda9b50d73adc9@canb.auug.org.au>
	 <20110728094819.22e19fe9.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Thu, 28 Jul 2011 13:10:13 -0700
Message-Id: <1311883813.6931.196.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 09:48 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> iscsi target code uses lots on network interface functions, so it
> should depend on NET.  Fixes many build errors when NET is not enabled:
> 
> ERROR: "kernel_sendmsg" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "in_aton" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "sock_release" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_listen" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_setsockopt" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_recvmsg" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_accept" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "sock_create" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_bind" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "in6_pton" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/target/iscsi/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20110728.orig/drivers/target/iscsi/Kconfig
> +++ linux-next-20110728/drivers/target/iscsi/Kconfig
> @@ -1,5 +1,6 @@
>  config ISCSI_TARGET
>  	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> +	depends on NET
>  	select CRYPTO
>  	select CRYPTO_CRC32C
>  	select CRYPTO_CRC32C_INTEL if X86

Committed as d52a10d00 and pushed into target-pending.git/for-next.

Thanks Randy!

--nab

