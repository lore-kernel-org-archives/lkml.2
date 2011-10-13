Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1JMGCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:02:42 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:55841 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1JMGCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:02:40 -0400
Date: Thu, 13 Oct 2011 17:02:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: linux-next: manual merge of the staging tree with the fbdev tree
Message-Id: <20111013170225.254bc2d590deee544913ab6c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Oct_2011_17_02_25_+1100_lXJMlOsr1lQ0zVs2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Oct_2011_17_02_25_+1100_lXJMlOsr1lQ0zVs2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/xgifb/XGI_main_26.c between commit 0d5c6ca30bb0
("staging: xgifb: use display information in info not in var for
panning") from the fbdev tree and commit fd26d42019cb ("staging: xgifb:
avoid direct references xgi_video_info") from the staging tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/xgifb/XGI_main_26.c
index f8b88ad,36db231..0000000
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@@ -1363,8 -1300,8 +1300,8 @@@ static int XGIfb_do_set_var(struct fb_v
  	return 0;
  }
 =20
- #ifdef XGIFB_PAN
- static int XGIfb_pan_var(struct fb_var_screeninfo *var, struct fb_info *i=
nfo)
+ static int XGIfb_pan_var(struct xgifb_video_info *xgifb_info,
 -			 struct fb_var_screeninfo *var)
++			 struct fb_var_screeninfo *var, struct fb_info *info)
  {
  	unsigned int base;
 =20
@@@ -1686,7 -1634,7 +1624,7 @@@ static int XGIfb_pan_display(struct fb_
  						> info->var.yres_virtual)
  			return -EINVAL;
  	}
- 	err =3D XGIfb_pan_var(var, info);
 -	err =3D XGIfb_pan_var(xgifb_info, var);
++	err =3D XGIfb_pan_var(xgifb_info, var, info);
  	if (err < 0)
  		return err;
 =20

--Signature=_Thu__13_Oct_2011_17_02_25_+1100_lXJMlOsr1lQ0zVs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOln7xAAoJEECxmPOUX5FEv88QAKUXFiGRtIxlu3mupisjhJT5
ySSbr+C3Ba2IZsE70TEx0XIe+/4Wh61pNUWrCV8wKStJZsKmn8UaRrZIyKnV8H1z
rYtLTZvNwdzmzYmreHEM98Wn5VO/0xDUtEsCTcTNcK2ApGow/csc3GbZv9dlPRC8
iduN/QO2RLsk13VmbiUBF7CakAygLg8AtctwvJERVab2vGs7wzdqMUscaeW2uRA2
TgMBdfiqXgkkTTSjdwptplSZc8vTb2TXDG4m93pEb5V7XZRnM5owp0iMbs6iuGUJ
tf1IAQAIqfVbhIjblcHsDB9T4E3y6lKdnXJ29YiZzJgiLXADMo/pXDFUeAyjZ8M0
uhPOL/S6X8VHFiTWAVLhMJVIvXTsqrNDPtRyBb+f8os0Wph22vTPdDAbEobDtpRL
pTmfExJ8/2OB75ptyEtUieVsmCAVJ/iedz2CQaMCMw0GOow2R3zEu7JskAI+x9YY
6Ewdzk/xId9eRuw41WndERudlSh9nrSkZxcVU8nnIt6IrJCjag3gv7EHBBhKCLOy
9nwENs+j3u0CYJQgv6XfrV2LsJNt0hTohxyYS/oWfaHtoR1AgzVdPM3SQE7yu98S
TPYhYYgmEYqEFahpZyJ/oH9BRvLspyo/Gk8RryORKjn3Eg0gg+KWa9SMaiqFSSTW
WEIFYMfhM4FkWNvAsKqk
=bzqx
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Oct_2011_17_02_25_+1100_lXJMlOsr1lQ0zVs2--
