Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1JLFe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 01:34:57 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54199 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1JLFe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 01:34:56 -0400
Date: Wed, 12 Oct 2011 16:34:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the staging tree with the tip tree
Message-Id: <20111012163452.7f1822bb8dca107daf26d28b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Oct_2011_16_34_52_+1100_KjS2T1Z9eTTy_3/i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Oct_2011_16_34_52_+1100_KjS2T1Z9eTTy_3/i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/hv/Makefile between commit 6f4151c89b7d ("x86: Hyper-V:
Integrate the clocksource with Hyper-V detection code") from the tip tree
and commit 46a971913611 ("Staging: hv: move hyperv code out of staging
directory") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/hv/Makefile
index 14e3c6a,e071c12..0000000
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@@ -1,14 -1,7 +1,6 @@@
- obj-$(CONFIG_HYPERV)		+=3D hv_vmbus.o
 -obj-$(CONFIG_HYPERV)		+=3D hv_timesource.o
  obj-$(CONFIG_HYPERV_STORAGE)	+=3D hv_storvsc.o
- obj-$(CONFIG_HYPERV_BLOCK)	+=3D hv_blkvsc.o
  obj-$(CONFIG_HYPERV_NET)	+=3D hv_netvsc.o
- obj-$(CONFIG_HYPERV_UTILS)	+=3D hv_utils.o
  obj-$(CONFIG_HYPERV_MOUSE)	+=3D hv_mouse.o
 =20
- hv_vmbus-y :=3D vmbus_drv.o \
- 		 hv.o connection.o channel.o \
- 		 channel_mgmt.o ring_buffer.o
- hv_storvsc-y :=3D storvsc_drv.o storvsc.o
- hv_blkvsc-y :=3D blkvsc_drv.o  storvsc.o
+ hv_storvsc-y :=3D storvsc_drv.o
  hv_netvsc-y :=3D netvsc_drv.o netvsc.o rndis_filter.o
- hv_utils-y :=3D hv_util.o hv_kvp.o

--Signature=_Wed__12_Oct_2011_16_34_52_+1100_KjS2T1Z9eTTy_3/i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlSb8AAoJEECxmPOUX5FEgZ8P/0XZqluX3ndm994fm36Xgp/n
AmsR//7QjK7FBKd80v35dP6QlILyhupwi3cjj2J4+umOWx9fPKvuHn7OwAkbTANV
wy3pfMeIk3EBzN9KuS4kRJUemkS37encdzDG7AEH7lUHIDzfsM2zKGWLYIFomrlm
mZlXnAvVgfvYnUmqgel3BIv/sV8DFPbR85xz4VeVyvISpYgu7AQsSKvlyRKNGFO/
A4DWDzGsJr8Daa3Lpi1HWqwNY1WYF/E8ZgbeSDF/qUp7T//a5RkNdn/wXB3OnGpE
tIx0RCFDoNZbn6S01U+rqbdAWXAo4qKNpV7P4yRgnqWJc58uoAjauXMPxPSVDSEK
U7hyJVRW0dlo6aZLvAwa4WNLGIfC69+NzJ4Sd8AqK5K2lrvJA9SKQpDS+DC/yxIy
Ogn/4a/yjSXNE2bD5f5JFFr3mviASbeLwDFUCqyIuQ7SV8ybDJgJNBtFmkaFsWz+
03kP7l5mF0bpSl0mrb97/GGwwMJe5Tj10j9FwD62UjeHK0D5vAAexDkEMWzINlA4
/nXIIUzSM7B90aVdINVz3QW7CSs/WEZEMQ/ZHI33BDHAjZHJRYH7BsMjGfxEVfY0
cKdl8gEN6nCRcv+GhrMZ4rRHFAuPpRC4Y8fSrJuiWlHhACDPNxvRml/Ep88N37dy
xC5HetRxN7Wx7T6hBXRT
=/sly
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Oct_2011_16_34_52_+1100_KjS2T1Z9eTTy_3/i--
