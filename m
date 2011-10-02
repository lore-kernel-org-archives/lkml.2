Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1JBVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 17:09:57 -0400
Received: from nm27-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.157]:32094 "HELO
	nm27-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754630Ab1JBVJv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 17:09:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 41220.65487.bm@omp1033.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LgvG7HhfO+3vOQGrA/OofC2QWAQiq3i0ZT4EKz9dFAxqneIGZlwqdaGjQY1Pu0u4jmxcUrpDJKs0u9LD2acI/SpCd+xfK9CxXI3tknEPRGaONoDC5iP4tU8SCaMtH2eGlrJK9AZtw2omBP/cdcab00N+Fd3mlke1UBN9pcN/s5s=;
X-YMail-OSG: _aJmS5EVM1kkqZxm55iPWhs6DprPImHQCE9vQwtkdhjCoQz
 uwYIPU9SqCW3gJeNpSqLql65FNwGEJAikKvHX9TemsqWIyZRdvBfhORxmn_U
 eo9aO42LkQhmsrNayLHMBihTpE.lC3fuEIVjMYtVxFwaOVuLfMpSEm3aJm1I
 qvTr8.WprSeT4gc7noVjgUQ2onC37nLKTpU4K4.zZ6H383VOP26SZjG_uqBU
 .TjV8rDm7KleBVvq8qve8zJsxJU8w13J1BsQ0WpGe.BVHOzSV7eCqFC94EPD
 wjI2E.DgSlKQrT0dER9H92cXkJEh_BS_VFaDxGO9Jvp4lLaPmX4mR0q5yr3D
 McQZWeGlrTJQ8Eu.vAAXIHx2XTXHmT4PVel2vALJQM7E5HWA8mK5mylsD.qX
 dmF6SKBUtGUh81ZUQaO9E5EdgV4VIyqnRrgPkoRWJLuai.Bqlb0_.i6iYg6F
 gkQ--
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com> <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com> <yunsjnln8it.fsf@aiko.keithp.com> <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com> <1317583219.81808.YahooMailNeo@web130113.mail.mud.yahoo.com>
Message-ID: <1317589790.89908.YahooMailNeo@web130109.mail.mud.yahoo.com>
Date: Sun, 2 Oct 2011 14:09:50 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
To: Keith Packard <keithp@keithp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mjg@redhat.com" <mjg@redhat.com>
In-Reply-To: <1317583219.81808.YahooMailNeo@web130113.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>The following patch fixes the problem for me:

[ snip ]

>the panel was disabled, which caused a 0 to be saved as the value to restore the brightness. intel_panel_disable_backlight
>merely sets the brightness to 0. Commenting out this call allows the correct brightness value to be saved.

> Thoughts?

Use this patch instead:

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index a9e0c7b..6f56676 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -262,8 +262,6 @@ void intel_panel_disable_backlight(struct drm_device *dev)
                dev_priv->backlight_level = intel_panel_get_backlight(dev);
                dev_priv->backlight_enabled = false;
        }
-
-       intel_panel_set_backlight(dev, 0);
 }
 
 void intel_panel_enable_backlight(struct drm_device *dev)

