Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1LCBjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:39:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1LCBht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:37:49 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=i9mJVuLNXSAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=YOHAqSSgXUB0i1AXnCkA:9 a=3AQ5DN9QyJt3oUb-8IIA:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=FsiXdNLXvM_hpptLwzoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203013745.600845619@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:36:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable-rt@vger.kernel.org
Subject: [PATCH 06/10] pci: Use __wake_up_all_locked pci_unblock_user_cfg_access()
References: <20111203013653.090501690@goodmis.org>
Content-Disposition: inline; filename=0006-pci-Use-__wake_up_all_locked-pci_unblock_user_cfg_ac.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Gleixner <tglx@linutronix.de>

The waitqueue is protected by the pci_lock, so we can just avoid to
lock the waitqueue lock itself. That prevents the
might_sleep()/scheduling while atomic problem on RT

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/pci/access.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index fdaa42a..1a6cc67 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -441,7 +441,7 @@ void pci_unblock_user_cfg_access(struct pci_dev *dev)
 	WARN_ON(!dev->block_ucfg_access);
=20
 	dev->block_ucfg_access =3D 0;
-	wake_up_all(&pci_ucfg_wait);
+	wake_up_all_locked(&pci_ucfg_wait);
 	raw_spin_unlock_irqrestore(&pci_lock, flags);
 }
 EXPORT_SYMBOL_GPL(pci_unblock_user_cfg_access);
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO2X1pAAoJEIy3vGnGbaoAf/oQAO49cJtpx076O8C/LBF7gjKI
RdJC0WiJeah0G0Uiy00vjxIbyCa5XVQIhKho3JuLdAr16pkrtMcmZy9jTYe7F9jH
/bqnqH/Gax8CgI6cYGGQwMbGuXvo9LdKf5eFDNa2IeGFS9ZFP7/mvjArgROdlkL7
xbENAcIQ3Sp+ZN47u38OpDkUJcjzS8T8j+3ZluyztGov1S/k1xcp/juw7fYbPY1o
wgB+B0Sk81Cicq+Yw57bm/SLb8ct5lpCkyduj/bxYF/Fg/hxxH/5bp23cVJxwmLb
TMahLynm52/gQ5E+tEs6jkoo5jdxDV+0wTQWnC213/AK+o8d0J5yXJiQjZY1+IJK
yduI132JCXu1WXMpK2VKAYImzh6SF/lwBnFgA9VOrkS857yNDOW+DycGY8UUKWy9
BFCONgPYEEnhtKlz5cvfU5ysLAOgttw3ZYj8Jm4u0FWFg250/AKRETvtPFYbSbXB
mvm7ljYaizsPd7o6RGb5QvDU6jRa/3gVcBbqxhCBZ8MalM6tJJqa38dqbmRw3Oh+
y3r4OAIdBL3X4rb6ushQlmTHj3Yp8vctnGkbKQQ5XLe9inxdqGJCrAbHmNh8daup
mTgaX06t6zAOIpx3CG9UO6Q4K/WkKBpPooYlcNduwAc7pvoN2Ntgqj598lrW7ky0
NfDrqI+rtbLWlipoKt1P
=xinp
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
