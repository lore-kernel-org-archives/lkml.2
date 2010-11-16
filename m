Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab0KPPQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:16:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47296 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0KPPQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:16:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=wx5x7i81vyyAiP6jq2bldLPjLWriQ3DWECIx78KJm9LUe+tLlJU81/tTQTC3ATHmHj
         R4NI1bKU0YD07SNPp8pq+TPPVGYmxn2Jk2Gpj/KrXgcmDx2tM7UQ9r9RhLM24UZk8TFc
         2X5WBGTl5FQFVJvqC8O/pesXemNJ6fTbwTLr4=
Date: Tue, 16 Nov 2010 16:15:41 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Jesper Juhl <jj@chaosbits.net>, David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
Message-ID: <20101116161541.32350d4c@varda>
In-Reply-To: <34565.1289866395@localhost>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com>
	<20101114181905.bc5b44f9.akpm@linux-foundation.org>
	<20101115113238.BF06.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
	<alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
	<34565.1289866395@localhost>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/xJiwiu0Vk9uAS7Wmt2/_nKG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xJiwiu0Vk9uAS7Wmt2/_nKG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

El Mon, 15 Nov 2010 19:13:15 -0500
Valdis.Kletnieks@vt.edu escribi=C3=B3:

> On Tue, 16 Nov 2010 00:31:00 +0100, Jesper Juhl said:
>=20
> > I'm not going into the debate about whether or not deprecating one tuna=
ble=20
> > for two years is sufficient or not. I'm simply going to mention one app=
=20
> > that I know of that needs to be converted to use "oom_score_adj" on my=
=20
> > box :
> >=20
> > [jj@dragon ~]$ uname -a
> > Linux dragon 2.6.37-rc1-ARCH-00542-g0143832-dirty #1 SMP PREEMPT Mon No=
v 15 2
> 2:01:52 CET 2010 x86_64 Intel(R) Core(TM)2 Duo CPU T7250 @ 2.00GHz Genuin=
eIntel
>  GNU/Linux
> > [jj@dragon ~]$ dmesg | grep oom_adj
> > start_kdeinit (1502): /proc/1502/oom_adj is deprecated, please use /pro=
c/1502/oom_score_adj instead.
>=20
> Make that 2 common apps:
>=20
> % uname -a
> Linux turing-police.cc.vt.edu 2.6.37-rc1-mmotm1109 #1 SMP PREEMPT Wed Nov=
 10 12:30:17 EST 2010 x86_64 x86_64 x86_64 GNU/Linux
> % dmesg | grep oom
> [   89.981594] sshd (4168): /proc/4168/oom_adj is deprecated, please use =
/proc/4168/oom_score_adj instead.
> % rpm -q openssh
> openssh-5.6p1-16.fc15.x86_64
>=20
> 5.6p1 is the latest-n-greatest released version on www.openssh.org, so so=
mebody
> probably needs to rattle their chain...

$ dmesg | grep deprecated
[    1.473365] udevd (662): /proc/662/oom_adj is deprecated, please use /pr=
oc/662/oom_score_adj instead.
$ apt-cache policy udev
udev:
  Instalados: 151-12.3
  Candidato: 151-12.3
  Tabla de versi=C3=B3n:
 *** 151-12.3 0
        500 http://es.archive.ubuntu.com/ubuntu/ lucid-proposed/main Packag=
es
        100 /var/lib/dpkg/status
     151-12.2 0
        500 http://es.archive.ubuntu.com/ubuntu/ lucid-updates/main Packages
     151-12 0
        500 http://es.archive.ubuntu.com/ubuntu/ lucid/main Packages
$ uname -a
Linux varda 2.6.36-00001-g90d39e9 #145 SMP PREEMPT Wed Oct 20 23:27:44 CEST=
 2010 x86_64 GNU/Linux

 Ubuntu 10.04 LTS

>=20

--Sig_/xJiwiu0Vk9uAS7Wmt2/_nKG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJM4qAdAAoJEDO4iEReSTB2VDMP/2LX0RTckeJd+vCutDwiUH93
YwDsPV86Zgw0dZW+XpmwLXyx6poyRHabEL67HI3EyjFfRzM4iogtn4AagqywKR4U
weefbfV57/L6ZWKX1qxCkpgP5pd1tQJPllHZkpv7g4Hjsv0SvI9iJf2ueYA88hTs
EyshYEpoNqjEUBLMawUzZCC0LWEXSirBLq+8M62RLKetUCSGgARJ4hST2zbJH1JH
CQ625771ZoOy6L7gxvzNqMsgoIVewK4a2IDLQdoZGRDfGOKx0lM9ASqjEuxPv2pt
Xn9XOUMKRJrvKPiczXhN4bQS2JE4InfnN5WxNOdNjWKICLAhDy/mRdTm8I3tU8/s
itGiz/gV1nXWKQHmXd8/pxcq9ifeDbw5/BsvINIkmj0Dprow6F0VgTxn9eFy4gyO
U/fdl3d5btdEap0sENtmEvfRGqynVrU8kFJhKTGjcccktUvnatcMIxwNQjA0E4yU
n+7EixeJpehZ9DX/pp6T6l+bX2Cja+RehQO1TSu90A7HOWP5j2bcbsH7cuY26yHE
0Twb/Dot0ZPa5iVTPf0gI0AElq69c8gGQmKAvxTSC5Ns+9qZPZAlUxwEtv/rPUbn
Bz+SdeRL/exXT+NN6Gvd67l7JrBqMmNGeIqGwilRLlA2RcdVMqVa7be7NFuij0OJ
dqLlfccNyYvZe8INlhqB
=DwVt
-----END PGP SIGNATURE-----

--Sig_/xJiwiu0Vk9uAS7Wmt2/_nKG--
