Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2ILGHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:07:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47521 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2ILGHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:07:31 -0400
Date: Wed, 12 Sep 2012 16:07:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Jonathan Cameron <jic23@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20120912160719.4377f041ac76ddfa13be7df1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Sep_2012_16_07_19_+1000_OheyccgV3SavDqX7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Sep_2012_16_07_19_+1000_OheyccgV3SavDqX7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/hid/hid-sensor-hub.c: In function 'sensor_hub_probe':
drivers/hid/hid-sensor-hub.c:599:3: error: too few arguments to function 'm=
fd_add_devices'

Caused by commit 401ca24fb34a ("HID: sensors: introduce sensor
framework") interacting with commit 6607bad3d763 ("mfd: core: Push
irqdomain mapping out into devices") from the mfd tree.

I have added the following merge fix patch and can carry it as necessary
(no action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 12 Sep 2012 16:03:55 +1000
Subject: [PATCH] HID: sensors: fix up for mfd_add_devices() API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/hid/hid-sensor-hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 34a35ba..4ac759c 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -596,7 +596,7 @@ static int sensor_hub_probe(struct hid_device *hdev,
 		}
 	}
 	ret =3D mfd_add_devices(&hdev->dev, 0, sd->hid_sensor_hub_client_devs,
-		sd->hid_sensor_client_cnt, NULL, 0);
+		sd->hid_sensor_client_cnt, NULL, 0, NULL);
 	if (ret < 0)
 		goto err_free_names;
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Sep_2012_16_07_19_+1000_OheyccgV3SavDqX7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUCaXAAoJEECxmPOUX5FE5jgP/iPMS+Ej/mzCSEyLlOlQ9e88
RghKzNoXVLpzOCj8NrrdPlwOEAYk1aqY45a1p6XGVRfgQh+fjCpMz+bnQESkKnhV
kew06t6Drxtpp0w9dJc8VVqehb+NbQVqpQvXZ36L7AL7Z8A8P4SjMzrjFf0K2qJY
3sgjRD+MrTkkT1pYyHP2P2fElmvMDNYBkbZXOGpPOYXmbCSiRGTSsvtZpLcl9ZCj
oEdjzulit65SjbsSrKWdaBx/puFHo7haLc5sgfhjBtVvsC/7DS/LReELmPWdFTaV
eYLH6HFv7evMtdS7gaCGFQnvVXRetkwqAarbNyI+ath9rV5kSJity/nwyJ8RpGqh
UFhFTDm9uaZ9rF4d8Jj4Q5RTzWIAJ4iYKDnKAz2dxH+D2Nod9V7+w/lP693PGIzi
R6I7MEy+LO3STG0nuXbWtI6VTSWXrXSyXJdM7UnG8t4vpRjv96Vdnfe7jpBJK2hH
WzYgAwhMbSgvTBG9fKzDXyFI3yApys5edPCw4472/NC+GdCNnTKHg+5dqe0IohHB
5gE9va3jklz0mD11VfLSDcyHrxbcPqvrVzHKMTN2Sc3Al2l09FZxx6pFMR7XYAiu
oYqAUb/tKy5ZQ1uUxxWYZ3FC5FMXx9IuiFiuONGU2Ufrt0QtGyi/IdTGUM6OiP5M
AfFEQPLwvgz2kEqdJDry
=QV+m
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Sep_2012_16_07_19_+1000_OheyccgV3SavDqX7--
