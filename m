Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1CHQpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:45:50 -0500
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:49309 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1CHQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:45:49 -0500
Date: Tue, 8 Mar 2011 17:45:08 +0100
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: dm-crypt@saout.de
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
Message-ID: <20110308164508.GA8729@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	dm-crypt@saout.de, linux-kernel@vger.kernel.org,
	Andi Kleen <ak@linux.intel.com>, Milan Broz <mbroz@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

dm-crypt in 2.6.38 changed to per-CPU workqueues to increase it's
performance by parallelizing encryption to multiple CPUs.
This modification seems to cause (massive) performance drops for
multiple parallel dm-crypt instances...

I'm running a 4-disk RAID0 on top of 4 independent dm-crypt(aes-xts)
devices on a Core2Quad 3GHz. This setup did overcome the single-CPU
limitation from previous versions and utilized all 4 cores for
encryption.
The throughput of this array drops from 282MB/s sustained read (dd,
single process) with 2.6.37.3 down to 133MB/s with 2.6.38-rc8 (which
nearly equals to single-disk throughput of 128MB/s - just in case this
matters).

This indicates way less parallelization now with 2.6.38 than before.
I don't think this was intentional :)

The dm-crypt per-CPU workqueues got introduced in 2.6.38 with
	c029772125594e31eb1a5ad9e0913724ed9891f2
Reverting dm-crypt.c to the version before this commit re-gains the same
throughput as with 2.6.37.


Submitters/Signers of c029772125594e31eb1a5ad9e0913724ed9891f2 CC:ed.


Thanks for your work & regards
   Mario
--=20
There are two major products that come from Berkeley: LSD and UNIX.
We don't believe this to be a coincidence.    -- Jeremy S. Anderson

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTXZdFBS+e2HeSPbpAQKziwf/f32YT/lMyVfgmOCVAoh7maD0O9qkYozT
FRBd2S8LXJmCqUDEJnVLenYCUoDo9UeFiAZ2wQ9cekBj0KZepPTSJuopJQlMYygk
9Am771WshE6mGEvcywdm5UXX/q1ICh8+b1ykzdNw6MLsTsLMULb6vdrXxe/n76me
O0SGv6haM6O8tC99MlN88gwvCBN+dQIdvVOM1cXdNfZpFouVcAaSYRgCm456Z4qV
91XKwcMeJTIVCLjNHzrFNWdPnKxiQ8egIRHJKzuwbBD1rg+JnLTqCnfEs1kvnZxL
u13MTemm0aHF4sb086DQxxfQPVUDc3ceUGitKpOQSOFSOia7LmPD+w==
=GgyN
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
