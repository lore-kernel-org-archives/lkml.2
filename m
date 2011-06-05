Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab1FERIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:08:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58778 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1FERH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type;
        b=OKmSRF+zb50pPI28nntel2TGR4CLiVTfItd6VGfWmSAwAtc4LMwjDSCQURGHOkFN7Q
         Vx2RVbxsghgs+XH0gu4d3O846JFYf7lNi/slqGTgy5B54b54XH9hb+M1NCzSSKceiM1J
         WFTEMKR1T/NvyzEzS+JA+D/a5EC4kWMHGPra0=
Date: Sun, 5 Jun 2011 20:10:42 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3.0.0-rc1: dmesg shows 'wlan%d' instead of 'wlan0'
Message-ID: <20110605201042.21c86763@sf>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+lgUSj/K3nJ0QJNuiAPvc9o"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+lgUSj/K3nJ0QJNuiAPvc9o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Recently I've noticed small discrepancy in dmesg:

$ { zcat messages.2.gz messages.1.gz; cat messages; } | egrep "(deauthen|Li=
nux version)"
...
May 21 22:01:31 sf kernel: [    0.000000] Linux version 2.6.39-00004-g29c77=
fa (slyfox@sf) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #116 SMP=
 PREEMPT Thu May 19 22:46:16 EEST 2011
May 24 05:37:54 sf kernel: [81845.885094] wlan0: deauthenticated from ...

Jun  1 22:38:38 sf kernel: [    0.000000] Linux version 3.0.0-rc1-00035-g79=
f3f61 (slyfox@sf) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #118 =
SMP PREEMPT Wed Jun 1 22:14:46 EEST 2011
Jun  1 23:41:23 sf kernel: [ 3877.773727] wlan%d: deauthenticating from ...

Jun  1 23:42:16 sf kernel: [    0.000000] Linux version 3.0.0-rc1-00035-g79=
f3f61-dirty (slyfox@sf) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) )=
 #119 SMP PREEMPT Wed Jun 1 23:35:43 EEST 2011
Jun  2 07:35:10 sf kernel: [ 5972.879970] wlan%d: deauthenticated from ...

Here we see 'wlan0' -> 'wlan%d' switch. I presume those lines go from firmw=
are
(and not from userspace).

The card is an iwl4965

10:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN [=
Kedron] Network Connection (rev 61)

--=20

  Sergei

--Sig_/+lgUSj/K3nJ0QJNuiAPvc9o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3ruJgACgkQcaHudmEf86q3PQCfadOI+AYwBmOs5785ITPcR+g+
9+oAn39cmDrXl5GE395hcGzovnF9FMH2
=1EiS
-----END PGP SIGNATURE-----

--Sig_/+lgUSj/K3nJ0QJNuiAPvc9o--
