Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab2KPJfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 04:35:39 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:54102 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2KPJfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 04:35:37 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: prevent stack buffer overflow in host_reset
Date: Fri, 16 Nov 2012 10:35:32 +0100
Message-ID: <2743667.hK8qPvyv2t@eto>
User-Agent: KMail/4.8.5 (Linux/3.6.4-9-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1353012706-28182-1-git-send-email-sasha.levin@oracle.com>
References: <1353012706-28182-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1374175.NP0D7WObFN"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1374175.NP0D7WObFN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Donnerstag 15 November 2012, 15:51:46 schrieb Sasha Levin:
> store_host_reset() has tried to re-invent the wheel to compare sysfs
> strings. Unfortunately it did so poorly and never bothered to check the
> input from userspace before overwriting stack with it, so something simple
> as:
> 
> echo "WoopsieWoopsie" >
> /sys/devices/pseudo_0/adapter0/host0/scsi_host/host0/host_reset
> 
> would result in:
> 
> [  316.310101] Kernel panic - not syncing: stack-protector: Kernel stack is
> corrupted in: ffffffff81f5bac7 [  316.310101]
> [  316.320051] Pid: 6655, comm: sh Tainted: G        W   
> 3.7.0-rc5-next-20121114-sasha-00016-g5c9d68d-dirty #129 [  316.320051] Call
> Trace:
> [  316.340058] pps pps0: PPS event at 1352918752.620355751
> [  316.340062] pps pps0: capture assert seq #303
> [  316.320051]  [<ffffffff83b3856b>] panic+0xcd/0x1f4
> [  316.320051]  [<ffffffff81f5bac7>] ? store_host_reset+0xd7/0x100
> [  316.320051]  [<ffffffff8110b996>] __stack_chk_fail+0x16/0x20
> [  316.320051]  [<ffffffff81f5bac7>] store_host_reset+0xd7/0x100
> [  316.320051]  [<ffffffff81e55bb3>] dev_attr_store+0x13/0x30
> [  316.320051]  [<ffffffff812f7db1>] sysfs_write_file+0x101/0x170
> [  316.320051]  [<ffffffff8127acc8>] vfs_write+0xb8/0x180
> [  316.320051]  [<ffffffff8127ae80>] sys_write+0x50/0xa0
> [  316.320051]  [<ffffffff83c03418>] tracesys+0xe1/0xe6
> 
> Fix this by uninventing whatever was going on there and just use
> sysfs_streq.
> 
> Bug introduced by 29443691 ("[SCSI] scsi: Added support for adapter and
> firmware reset").
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

That revision is in 3.2 and all following, so I think this needs to go into 
stable, too.

Eike
--nextPart1374175.NP0D7WObFN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlCmCOQACgkQXKSJPmm5/E7lZQCeOmTD0qnSH3eVJawsiZ3sbRbS
GBYAn0Dxd5rJGYClsVtSgSeQ9ldnoT3G
=tKkJ
-----END PGP SIGNATURE-----

--nextPart1374175.NP0D7WObFN--

