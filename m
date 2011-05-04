Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1EDRze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:55:34 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55334 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1EDRzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:55:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Matthew Wilcox <matthew@wil.cx>
Cc: scameron@beardog.cce.hp.com, Tomas Henzl <thenzl@redhat.com>,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o path to ensure commands don't get lost.
In-Reply-To: Your message of "Wed, 04 May 2011 11:37:35 MDT."
             <20110504173735.GB22953@parisc-linux.org>
From: Valdis.Kletnieks@vt.edu
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com> <20110503195849.5478.13229.stgit@beardog.cce.hp.com> <4DC13566.5070203@redhat.com> <20110504125212.GC5997@beardog.cce.hp.com> <10639.1304530101@localhost>
            <20110504173735.GB22953@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1304531662_7352P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 May 2011 13:54:22 -0400
Message-ID: <11821.1304531662@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DC192CF.00CB,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1304531662_7352P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 May 2011 11:37:35 MDT, Matthew Wilcox said:
> > This probably needs a comment like
> > 	/* don't care - dummy read just to force write posting to chipset */
> > or similar.  I'm assuming it's just functioning as a barrier-type flush of some sort?
> 
> It's a PCI write flush.  It's not clear to me why it's needed here,
> though.  The write will eventually get to the device; why we need to
> make the CPU wait around for it to actually get there doesn't make sense.

Exactly why I think it needs a one-liner comment. :)



--==_Exmh_1304531662_7352P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNwZLOcC3lWbTT17ARAoxZAKCC6uTzzQpErmifrHpBnMEda5m7+gCgsmSa
hihEfg9c6H21ti8tVTcsssQ=
=akVN
-----END PGP SIGNATURE-----

--==_Exmh_1304531662_7352P--

