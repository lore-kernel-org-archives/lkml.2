Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0JAIs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 04:48:27 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:23510 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899Ab0JAIs0 (ORCPT
	<rfc822;groupwise-jlee@novell.com:7:2>);
	Fri, 1 Oct 2010 04:48:26 -0400
Message-Id: <4CA62CF0020000230002124F@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 01 Oct 2010 02:48:16 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <jerone.young@canonical.com>, <melchior+kernel@cmu.edu>,
        <rui.zhang@intel.com>, <lenb@kernel.org>, <patrol@sinus.cz>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMI to disable Vista compatibility on MSI GX723
 Notebook
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part614C8540.6__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part614C8540.6__=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hi Matthew, 

Thank's for your review!

於 四，2010-09-30 於 14:25 +0100，Matthew Garrett 提到：
> On Thu, Sep 30, 2010 at 06:44:11PM +0800, Lee, Chun-Yi wrote:
> > The brightness control hotkey don't work with Vista compatibility
> > , because MSI GX723 included a infinite while loop in DSDT when
> > brightness control hotkey pressed.
> > MSI GX723 used Nvida video card, the infinite while loop must be a
> > workaround with Nvidia's Vista driver.
> 
> While this would work, it seems likely that the expected behaviour is 
> for the graphics driver to call the NVIF method. We don't do that as 
> yet, but when we do I'm worried about it potentially resulting in this 
> system being in an unexpected state (NVIF is used, but we don't claim to 
> be Vista). Can you add a comment indicating that it should be reverted 
> once nouveau grows support?
> 

I added comment to source code to remind need remove the MSI GX723 from
blacklist table after nouveau driver support NVIF method.

The attached file is new patch. Do I need send the patch to kernel mail
loop by git send-mail again?


Thank's
Joey Lee


--=__Part614C8540.6__=
Content-Type: text/plain; name="0001-DMI-to-disable-Vista-compatibility-on-MSI-GX723-Note.PATCH"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="0001-DMI-to-disable-Vista-compatibility-on-MSI-GX723-Note.PATCH"

>From c9541bb35389c3ccd96a49e9f30509e5bebae760 Mon Sep 17 00:00:00 =
2001=0AFrom: Lee, Chun-Yi <jlee@novell.com>=0ADate: Fri, 1 Oct 2010 =
16:28:29 +0800=0ASubject: [PATCH] DMI to disable Vista compatibility on =
MSI GX723 Notebook=0A=0AThe brightness control hotkey don't work with =
Vista compatibility=0A, because MSI GX723 included a infinite while loop =
in DSDT when=0Abrightness control hotkey pressed.=0AMSI GX723 used Nvidia =
video card, the infinite while loop must be=0Aa workaround with Nvidia's =
Vista driver.=0A=0AThis patch should be reverted  once nouveau grows =
support to call=0ANVIF method in DSDT.=0A=0ASigned-off-by: Lee, Chun-Yi =
<jlee@novell.com>=0A---=0A drivers/acpi/blacklist.c |   17 ++++++++++++++++=
+=0A 1 files changed, 17 insertions(+), 0 deletions(-)=0A=0Adiff --git =
a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c=0Aindex f761960..fd24=
325 100644=0A--- a/drivers/acpi/blacklist.c=0A+++ b/drivers/acpi/blacklist.=
c=0A@@ -236,6 +236,23 @@ static struct dmi_system_id acpi_osi_dmi_table[] =
__initdata =3D {=0A 		},=0A 	},=0A 	{=0A+	/*=0A+	 * There =
have a NVIF method in MSI GX723 DSDT need call by Nvidia=0A+	 * driver =
(e.g. nouveau) when user press brightness hotkey.=0A+	 * Currently, =
nouveau driver didn't do the job and it causes there=0A+	 * have a =
infinite while loop in DSDT when user press hotkey.=0A+	 * We add MSI =
GX723's dmi information to this table for workaround=0A+	 * this =
issue.=0A+	 * Will remove MSI GX723 from the table after nouveau =
grows support.=0A+	 */=0A+	.callback =3D dmi_disable_osi_vista,=0A+	=
.ident =3D "MSI GX723",=0A+	.matches =3D {=0A+		     =
DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),=0A+		   =
  DMI_MATCH(DMI_PRODUCT_NAME, "GX723"),=0A+		},=0A+	},=0A+	=
{=0A 	.callback =3D dmi_disable_osi_win7,=0A 	.ident =3D "ASUS K50IJ",=0A=
 	.matches =3D {=0A-- =0A1.6.0.2=0A=0A
--=__Part614C8540.6__=--
