Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0HYItW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:49:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57411 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0HYItU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:49:20 -0400
Date: Wed, 25 Aug 2010 10:49:12 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>
Subject: df486a25900 broke arm/mx1_defconfig and probably more
Message-ID: <20100825084912.GA10293@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

trying to compile mx1_defconfig ends in:

	  LD      .tmp_vmlinux1
	fs/built-in.o: In function `nfs_callback_authenticate':
	compr_zlib.c:(.text+0x7d044): undefined reference to `svc_gss_principal'
	make[2]: *** [.tmp_vmlinux1] Error 1
	make[1]: *** [sub-make] Error 2
	make: *** [all] Error 2
	make: Leaving directory `/ptx/work/octopus/WORK_2_A/ukl/kbuild/imxdefconfigs/mx1'

bisecting yields

	df486a2 (NFS: Fix the selection of security flavours in Kconfig)

as first bad commit.

	$ grep -E -e '(NFS|SUNRPC_GSS|CRYPTO|RPCSEC)' .config
	# CONFIG_USB_FUNCTIONFS is not set
	CONFIG_NFS_FS=y
	CONFIG_NFS_V3=y
	# CONFIG_NFS_V3_ACL is not set
	CONFIG_NFS_V4=y
	# CONFIG_NFS_V4_1 is not set
	CONFIG_ROOT_NFS=y
	# CONFIG_NFSD is not set
	CONFIG_NFS_COMMON=y
	# CONFIG_RPCSEC_GSS_SPKM3 is not set
	# CONFIG_CRYPTO is not set

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
