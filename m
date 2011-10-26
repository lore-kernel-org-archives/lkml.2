Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1JZDZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 23:25:41 -0400
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:36452 "HELO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754582Ab1JZDZj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 23:25:39 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Oct 2011 23:25:39 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 133763.55761.bm@omp1052.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=yOgs8FQD0G7WD54/UkdVUJsgK5KjAJqqjy93GCyslCwpn8WCeG1vVw5tSqu8rwsXFGxYO6jzQtYycOqZruugm7UnlmcKR3ohLwlTw0HlqbF6BETDChMFiu+7hGs0lB6/0KiQdw9ZOfrI2WvYvMJJxLl9dGkw9SGRNTZzeZ3FbVI=;
X-YMail-OSG: zQPUpmgVM1mj2gbY2cdWSgb2XWOlwNuL4cQvSw8O5930NeY
 L7aMOKg5jVR_AZy4dnxrroIPPE45HockVQYiUv912qX9SUi8DyAZ6wVQ_ngs
 IZW3w9pys0bp3e1Bp2mnkZ_aL37z5mCaKPYgHRqClHUi_ACvBcY_O1m4uBEe
 qwoxNtgYZQXD9VJF4qqca1AFO8w.LGw4mSsYlgdM3Ek9805yikhyytZIBs8s
 _deUFQqJZ7BKkfHQ7Y1YVbvKWIiiyE0rvTv_zCGPKgVrQonGy3N6wQNN0HEe
 zGY9.vnhh_CyL.2S.K2RNoDeuffoZFNDF_7mJGdl0dQF9MxbHYGbR2XP9a1c
 _DsAgLQoixhCgh73ZSuE262bq2T.Ks9X6GrLkVHH7kJvYB74tT1QA3xZz5kP
 6thR_mWaeLdOHO3pY5ZkXdZ.AZ1XKO1Ii421DMSor1OfiC2oJW1vPJAeHZ.c
 8gSQ6d8Qq1RC1kflfm0DdkIxVbStRyJNGHkQIH_q7iDJIJvTq87xEdBN75Pq
 HXCDGKeVoLqCVzC9y491KjGfuUDW5yHxBzPlFz.6.QSYiwVFoIFfnhQ_7olT
 kXoH3n2Is2d.sB.Sx9NRNlzPEXTy69h9N_JTV7OeZ0DDk5Hp8ryWUNyhyud.
 rIniXiHwC5WWGb3OEKE.ZC.NcUaNgadoTAzVD
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com> <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com> <yunsjnln8it.fsf@aiko.keithp.com> <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com> <1317583219.81808.YahooMailNeo@web130113.mail.mud.yahoo.com>
Message-ID: <1319599156.52195.YahooMailNeo@web130106.mail.mud.yahoo.com>
Date: Tue, 25 Oct 2011 20:19:16 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
To: Keith Packard <keithp@keithp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mjg@redhat.com" <mjg@redhat.com>, Kamal Mostafa <kamal@canonical.com>
In-Reply-To: <1317583219.81808.YahooMailNeo@web130113.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



At the request of Kamal Mostafa, an Ubuntu kernel developer, I am resubmitting this patch which fixes my backlight issue.
It seem that there are a number of people with different machines that have this problem:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/872652
https://launchpad.net/~kamalmostafa/+archive/stuck-backlight
and
https://bugs.freedesktop.org/show_bug.cgi?id=41926

The goal here is to either get the patch included, or provoke a discussion of the issue.

This patch is against 3.1 rc8 with Keith Packard's drm-intel-fixes merged in.

Putting printk's in ./drivers/gpu/drm/i915/intel_panel.c showed that intel_get_brightness was being called after 

the panel was disabled, which caused a 0 to be saved as the value to restore the brightness. intel_panel_disable_backlight
merely sets the brightness to 0. Commenting out this call allows the correct brightness value to be saved.

Signed-off-by: Alex Davis<alex14641@yahoo.com>
Tested-by: Kamal Mostafa <kamal@canonical.com>


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

--       
