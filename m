Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab1JCVLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:11:18 -0400
Received: from nm24-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.226]:29168 "HELO
	nm24-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752190Ab1JCVLL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:11:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 907717.13118.bm@omp1014.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=uGRESrnbtvn7CPmTam9yfsVBH/6LWfbMH5WQ4pXgU4eyLvT7QgE7w5n45dSUmzTayx/PAzXRmUWSLEAtX18R89IYfEwcyZDdvzJ29AWcIzR0Ypg/9BDhJD2TO3ZfkUBX/NbD64BoaO79azBq3PGkudohT4GGpI85lU51T1oXTYk=;
X-YMail-OSG: vf9iMQMVM1lgweWFf32fUIZbYizXedcFPYIIL0kIGfbJFcZ
 57YjEtDjMpy0N2Kc.yitY4LHJSz6C3hJ7512cVeKv2Ui3MmktDFDnKxqCkvv
 o7u87sT2CyebgfxvTn4Brb5ccAZUm5inxyoxTTyiDgNdSKqOlUg8dLLIOM1B
 kfwk6R0MmUd5LgV75Vuut6RUgFMe.MQhKxoqQpk_lCNabZaSs0_1DRj9iF66
 cpuYNItDKbUpCvUCKlRgxUdmrQILenBipLd9sbenUuTxrSPJVQ7JAfzbEygV
 pG9TCbL_drm3Ak5TSNMcNs5SngrysynESERjG9.aujlW1set0jtziRm3MTGe
 SSudtStT5sRyiDHJM_ZA2EaUxWiocK0NaPrAM4Z0Sx90KroBn8CzdbESU5ID
 yWbbLb4Tie2JU3EaZBsapEZGs1hkY9YDnZnHXxO8E_9S3gosVULU6CHRS3nV
 2Z9AxdKgHGVdDVLGGgBEC8dXo0KLwtt0C3PBMvrdWCj.CnuzWM3Iw71ctmC5
 NwYKYkc86fig.4Zt5bw2WpXGKKNSw8XjEy9n8ynpbcA--
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316957834.67111.YahooMailNeo@web130112.mail.mud.yahoo.com>
Message-ID: <1317676210.22894.YahooMailNeo@web130106.mail.mud.yahoo.com>
Date: Mon, 3 Oct 2011 14:10:10 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
To: "terraluna977@gmail.com" <terraluna977@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1316957834.67111.YahooMailNeo@web130112.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Alex Davis <alex14641@yahoo.com>
>To: "terraluna977@gmail.com" <terraluna977@gmail.com>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
>Cc: 
>Sent: Sunday, September 25, 2011 9:37 AM
>Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
>
>I'm having the same problem.
>
>http://marc.info/?l=linux-kernel&m=131695739702141&w=2
>
>Please keep me on the CC list for this thread.
>
>Thanks.
>
>
> I code, therefore I am

The following patch fixed my backlight issues:

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index a9e0c7b..6f56676 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -262,8 +262,6 @@ void intel_panel_disable_backlight(struct drm_device *dev)
         dev_priv->backlight_level = intel_panel_get_backlight(dev);
         dev_priv->backlight_enabled = false;
     }
-
-    intel_panel_set_backlight(dev, 0);
 }
 
 void intel_panel_enable_backlight(struct drm_device *dev)

I've been using it since yesterday morning with no issues.

