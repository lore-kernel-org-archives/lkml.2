Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2GXOHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:07:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41176 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679Ab2GXOHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:07:17 -0400
Message-ID: <1343138818.5132.98.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 028/108] sched/nohz: Rewrite and fix load-avg computation --
 again
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jul 2012 15:06:58 +0100
In-Reply-To: <20120723010655.768372060@decadent.org.uk>
References: <20120723010655.768372060@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LEuQA681sV3Emeo79qI2"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LEuQA681sV3Emeo79qI2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-23 at 02:07 +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>=20
> commit 5167e8d5417bf5c322a703d2927daec727ea40dd upstream.
>=20
> Thanks to Charles Wang for spotting the defects in the current code:
>=20
>  - If we go idle during the sample window -- after sampling, we get a
>    negative bias because we can negate our own sample.
>=20
>  - If we wake up during the sample window we get a positive bias
>    because we push the sample to a known active period.
>=20
> So rewrite the entire nohz load-avg muck once again, now adding
> copious documentation to the code.
[...]

Based on <http://bugs.debian.org/674153>, I think we also need:

556061b sched/nohz: Fix rq->cpu_load[] calculations
5aaa0b7 sched/nohz: Fix rq->cpu_load calculations some more

Does this ('sched/nohz: Rewrite and fix load-avg computation -- again')
depend in any way on those, or are they separate fixes?

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-LEuQA681sV3Emeo79qI2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUA6sAue/yOyVhhEJAQo9Hw//R4WdJl6RWUusHnROyn2mg13+kq0COu7f
AIUP+aEhQ9b+3gYXX6bYXfVy7SCDZY0ZkJizNq/jxF0VWJlFivyhmmEZb1Fg17Q4
wKeShvdee39vdrRHzEPKMPSoUBSdPeuxn7EvtohX7D24qkCU+GKhGSdDARI13coV
gUqfZwYAS1MZi+X/I/+PCPmQ3vrAQrKuuDL42s4PXrsan0l4si3uqIgOwUzKSLg0
k7l3BsiWdQqgDD1FyCM580x5Uo0Pamc1ot2CGBtqjxM+J4XbErhIBdvoOa25nmqF
a2NB1sYXOB0PlVIa4tz4OV3PHShHv/AvkEUI+tKHctuPR0k+pc6uZtu/wDvk86Nv
QyHZfNeuUxSPPtMUhOMJRIYQF8mHivlnI33PR/SUhozulzHV819nx313hhJFKYRb
cXwnPsNFPcYFjG6sA5xy/NY61i7EsYmla0deG9cgGHX+7y9EWBz5LQ2hlsCAdl8z
FatbsUZ3E2FfWfYyhEpWNh0QZW8meLTP7oAvkUw24Mmtgr0iVSKDdtcmet7ZpGSN
+rpc0ixPdgokAGsx2JbKCoqmM1VvgmtJAu+aQ8A/WsZK9gwDvNqIiYdRqJKsiclg
LtRwLp9dHNuXu4WxuXyXx4acddMzjXLRXDKv4rUQ3MvclWlbMO5hCKiE9l39ZFoR
nSGH9YUXNj0=
=PciL
-----END PGP SIGNATURE-----

--=-LEuQA681sV3Emeo79qI2--
