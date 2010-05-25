Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab0EYC50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 22:57:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36362 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab0EYC5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 22:57:25 -0400
Date: Tue, 25 May 2010 12:57:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Gross <mgross@linux.intel.com>
Subject: linux-next: build failure after merge of the viafb tree
Message-Id: <20100525125718.703fdc08.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_May_2010_12_57_18_+1000_rDkOHSP.=IhO7+Ce"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_May_2010_12_57_18_+1000_rDkOHSP.=IhO7+Ce
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jonathan,

After merging the viafb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/video/via-camera.c: In function 'viacam_streamon':
drivers/media/video/via-camera.c:1032: error: implicit declaration of funct=
ion 'pm_qos_add_requirement'
drivers/media/video/via-camera.c: In function 'viacam_streamoff':
drivers/media/video/via-camera.c:1052: error: implicit declaration of funct=
ion 'pm_qos_remove_requirement'

Caused by commit d9acc26333e04633af61e634a5bd91c066162fca ("Add the viafb
video capture driver") interacting with commit
ed77134bfccf5e75b6cbadab268e559dbe6a4ebb ("PM QOS update") from Linus'
tree.  The pm_qos_..._requirement functions were renamed.

I have used the viafb tree from next-20100524 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_May_2010_12_57_18_+1000_rDkOHSP.=IhO7+Ce
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv7PI4ACgkQjjKRsyhoI8wtRwCgg6ra933MwJ81EC2MboXhPxBa
h7YAnAzGfii1VBM79z+CAi0S0qpdDvn/
=at90
-----END PGP SIGNATURE-----

--Signature=_Tue__25_May_2010_12_57_18_+1000_rDkOHSP.=IhO7+Ce--
