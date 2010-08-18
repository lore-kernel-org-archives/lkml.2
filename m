Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0HRAlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:41:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44553 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab0HRAlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:41:06 -0400
Date: Wed, 18 Aug 2010 10:40:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gwendal Grignou <gwendal@google.com>,
        Grant Grundler <grundler@google.com>
Subject: linux-next: build failure after merge of the libata tree
Message-Id: <20100818104057.5fdaf20d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_Aug_2010_10_40_57_+1000_+LTNxUCFzUyOTRuK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Aug_2010_10_40_57_+1000_+LTNxUCFzUyOTRuK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

After merging the libata tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/ata/libata-transport.c: In function 'ata_attach_transport':
drivers/ata/libata-transport.c:678: error: implicit declaration of function=
 'kzalloc'
drivers/ata/libata-transport.c:678: warning: assignment makes pointer from =
integer without a cast
drivers/ata/libata-transport.c: In function 'ata_release_transport':
drivers/ata/libata-transport.c:741: error: implicit declaration of function=
 'kfree'

Caused by commit 97395d39931160a171959ac2e1fbff1caba3374b ("[libata] Add
ATA transport class") neglecting to include linux/slab.h.   See Rule 1 in
Documentation/SubmitChecklist.

I have used the libata tree form next-20100817 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__18_Aug_2010_10_40_57_+1000_+LTNxUCFzUyOTRuK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMaywZAAoJEDMEi1NhKgbs0+wIAIjaC+SjlEzbSvmavh2ymgIt
Aj+3dkj+QuBpbAwlmE94iJ9L9gcu2ROnfbJ9HmCDo2ZXsHP4yyoCuC3J8EWlEFPj
T58NiQCK6tE+R8reFeAI5QJB8utYsli4/aldx8rlvrGSka13UgyZHdvh93lR0kjo
GFk7giFqZ5+xBH8AWRVdyaLE960NOoLUXWB8BfejnG7fS+EkaZt97cRiZkDowKQS
44jGm9FE/AZmTwrdbTSD0DySiS/+EdB+pgd7ELXMySh85Yt4EKssBRmCU4lWan9I
06cTXYtiDOF6JSnunhopsh1Ym+jq51mm8PWoL+CEwzp7xKsrDmy/MetqcGOpRuw=
=4C4E
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Aug_2010_10_40_57_+1000_+LTNxUCFzUyOTRuK--
