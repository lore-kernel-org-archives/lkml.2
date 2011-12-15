Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab1LOVFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 16:05:49 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58184 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1LOVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:05:48 -0500
Date: Thu, 15 Dec 2011 16:05:39 -0500
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: pjones@redhat.com, yinghai@kernel.org
Subject: [GIT PULL] ibft fix for 3.2-rc6
Message-ID: <20111215210538.GA12248@konrad-lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following branch:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft.git linux-next

which has a fix to make the ACPI table called 'iSCSI Boot Format Table'
(IBFT) be found by the iscsi-ibft driver when booting under UEFI.

The functionality to grab the APCI IBFT was added some time ago, but we
did not have the UEFI box to test it. Now that it has been tested it was
uncovered that the ACPI parser code was run way to early - so it did not
parse the iBFT table at all. This patch fixes it by doing the ACPI parsing later.
The legacy iBFT searching is not affected (which is to scan 640K->1MB
for the iBFT signature) and works correctly.

Please pull!

Yinghai Lu (1):
      ibft: Fix finding IBFT ACPI table on UEFI

 drivers/firmware/iscsi_ibft.c      |   42 ++++++++++++++++++++++++++++++++++-
 drivers/firmware/iscsi_ibft_find.c |   26 +--------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJO6mEeAAoJEFjIrFwIi8fJaYUH/3noSP91XL8h422izYd6v52C
3IFLDqH7XCQ+LEaHdJ06CM9/EYzouzHbw+aCLY8sH4bIKa0aG8ZpK9c+vcy3vrcs
QolmQGTTaKT4MUZ4473L/uSnQt9ZLT2NtiBh9jFwYOApwzQPRg9PQjhIh4hcecVt
k2LKXvIua4OHvmZSO5UXwYQVc/GrI56MPQ/ovySF6IfwV8kz3rxVUKcvwaog9N4N
xP3L6YSNr5+lOk4IW91Pp9m7/7YXfaJ+17sfm0QWzHlvvFld9t52njTeVw9O7P5B
ZhwLx+Tw76RCjlQR0ZKii7dSfLx9Hd3E6b1Sksz1mBmn/G4hb+jjOe5KCO0tWyI=
=nORH
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
