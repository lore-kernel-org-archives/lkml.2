Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab2EWCIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:08:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41788 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025Ab2EWCIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:08:23 -0400
Date: Wed, 23 May 2012 12:08:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120523120817.07529208f2efb9abf3222240@canb.auug.org.au>
In-Reply-To: <20120522.150525.1965961563976193101.davem@davemloft.net>
References: <20120522182010.f93a38e575ed34e88de5b787@canb.auug.org.au>
	<20120522.150525.1965961563976193101.davem@davemloft.net>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_12_08_17_+1000_9DV9eBwsJW8wyGzI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_12_08_17_+1000_9DV9eBwsJW8wyGzI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 22 May 2012 15:05:25 -0400 (EDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 22 May 2012 18:20:10 +1000
>=20
> > After merging the final tree, today's linux-next build (sparc32 defconf=
ig)
> > failed like this:
> >=20
> > arch/sparc/kernel/time_32.c: In function 'timer_interrupt':
> > arch/sparc/kernel/time_32.c:105:3: error: invalid use of undefined type=
 'struct clock_event_device'
>  ...
> > I have no idea what caused this, I did not get this yesterday.  I have
> > left this build broken for today.
>=20
> It builds cleanly in Linus's tree, and I have no local changes in sparc-n=
ext.

I bisected it down to my merge of the tip tree (commit 26b38c5887 in
next-20120522).  I only enable GENERIC_CLOCKEVENTS for sparc64 - I missed
a subtle interaction between commit 62f082830d63 ("sparc32: generic
clockevent support") from the sparc-next tree and commit ded1cc5cfc3b
("sparc: Use: generic time config") from the tip tree.

I will fix this up in linux-next today.  Sorry for the noise.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_May_2012_12_08_17_+1000_9DV9eBwsJW8wyGzI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvEaRAAoJEECxmPOUX5FEK3wP/3SRXiCTj8eJovLYzCCeVJ8Q
cRcOhmdeOK6aZ5/o2U/1gPIQfKmgiA1Jj0KJpPicWQZpbIViZt4BZvA9rdT1WQ9E
SV2CeeMMfcgUuzCcesCxxnItn8Qisv4HR+2xggUnmcZEK2s2MT7zoCSNqCqq/Pbu
RiZoydBd45slmySiR92fRsXaqjXmq2HDcoZlLLD4Naj0oJ0XgOz3UnA2DpZgkiGA
zJiCFHyAzFeEgo8Q7qO1tPEFbwt3hqx9PQIYnPSxWWd3W63wwM/yifpmDS5m1iIA
LjaQYYDQEacm2npl09nnzJo4KUsqLxdqFRbRapKAAcvsL440QpLv/Ji7ExlfNm+s
WtobDKiXU7hA65Qvyxy3Zwdyd33INuGO7p2vWg5VcLU2Dq/1747r1RiqaMkLvCWG
GqTidZPhXEFxD9fv1e+Cudk9g/GrF3cWft4xhHyR2AhmWo8S4kBr/SEKWENXiBG/
YCyZ10zSNMQbiLypmi71bhrI/FnP6ZYxo3chZFpkt3G3vfDOFisXh70xFXIEBNv1
Yv+pjRWXQMtBpL/jLU6K9qbGxyy/rdLU9riuoM6OBqNReQyuReSd2YlzXiJacjOg
ehdt/4T40bqFmDhK6Yx3ykq6jDTQrYlzFtFwLY2Wd6cjApwfTaCHquKbOYQWw0um
kvAQvfH+PwAxrcIRSct+
=ijvA
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_12_08_17_+1000_9DV9eBwsJW8wyGzI--
