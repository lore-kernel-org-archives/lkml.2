Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab1JBTU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:20:27 -0400
Received: from nm5.bullet.mail.ac4.yahoo.com ([98.139.52.202]:22604 "HELO
	nm5.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751620Ab1JBTUU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:20:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 582517.72480.bm@omp1034.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hO+eaC1lHhHBEZpZWrOee1nOH38pAfmD6z6oFch8bYnd4ocPEIAV3311kJCWiP1drfK71t4BBy3ckHC78Y8R01jfjBjas9tKAWUa+6tTrzW7fiuulQ+4eTNGnS9VnvZdnsXLDuA6Zxr77q7bH36KlY3/g0od3iQVGhsA9XijA88=;
X-YMail-OSG: 0l8RzOMVM1keeZri6pKZfh1gCkzZ0qCefwPEa0uj_jHB6BV
 YUyLHE14zs8KH6cA1LZj.qbLG5XX9hJ2tzEW29zC1aIYoux_CG63aPDhBY8X
 maJdmSbhAH5kRYsNv_D5FujHfXWUqjwiqVVfQF052crUyeXsCCvpFuFQuiNf
 n.jmn_TaBXdnHAoYjTG2KadS2NwSWoFDYOT1TcxJ84GElBHGGUg50ZbeTXlw
 JeWPrpm3XoDwT7aCJAZnbR2Zhy0riPwpzTLGp7EowpKAM2TKLSwVyMDYbPhN
 Md5E8EUMMDP3.5gmK4kffT7M5E.O39SQHUUe9OMYO78t4i1gx2X2k1IQltG8
 fOfFzBj5uUxA7Thtlm6afnllhVpJdX2xanHZj2HBtseDdHxtF9m9s2.S.YRF
 9i8CzPOUzVZ_BqhyMQjFc75UiAsDwZ6cQPioDLdicwSHsNwyAcFMN22ywtBL
 JpZaY1OqiFbEMe99cBJAS.rBoKe0WrP2av4igUSpl4XmmPnun3Sh3J93g2mV
 iE9ehKJw8pEPjml3L5WOoxjJ2xh8-
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com> <yunvcsim1wk.fsf@aiko.keithp.com> <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com> <yunsjnln8it.fsf@aiko.keithp.com> <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com>
Message-ID: <1317583219.81808.YahooMailNeo@web130113.mail.mud.yahoo.com>
Date: Sun, 2 Oct 2011 12:20:19 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.with 3.1
To: Keith Packard <keithp@keithp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mjg@redhat.com" <mjg@redhat.com>
In-Reply-To: <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometime in the past: Keith Packard <keithp@keithp.com> wrote:

>> One good thing about the 3.1 kernels is that I now have the /sys/class/backlight/intel_backlight directory
>> in addition to /sys/class/backlight/dell_backlight. With intel_backlight, I can control the LCD brightness;
>> dell_backlight never worked, neither in 3.0 or 3.1.
>
>Can you tell if the screen is blank with the backlight on, or is the
>screen drawn correctly and the backlight off?
>
>If the screen is blank but the backlight is on, then you may want a
>patch which is on my drm-intel-fixes branch.
>
>git://anongit.freedesktop.org/~keithp/linux
>
>If the screen is drawn, but the backlight is off, you may want to try
>reverting the native backlight patch:
>
>aaa6fd2a004147bf32fce05720938236de3361d9
>
>Author: Matthew Garrett <mjg@redhat.com>  2011-08-12 03:11:33
>Committer: Keith Packard <keithp@keithp.com>  2011-08-15 12:10:25
>Parent: 302983e9059e9ef5de3ca7671918eeb237c5971e (drm/i915/pch: Fix integer math bugs in panel fitting)
>
>Not all systems expose a firmware or platform mechanism for changing the backlight intensity on i915, so add native driver support.
>
>-- 
>keith.packard@intel.com


The following patch fixes the problem for me:

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 31da77f..9c16243 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -126,8 +126,6 @@ static void intel_lvds_disable(struct intel_lvds *intel_lvds)
         stat_reg = PP_STATUS;
     }
 
-    intel_panel_disable_backlight(dev);
-
     I915_WRITE(ctl_reg, I915_READ(ctl_reg) & ~POWER_TARGET_ON);
     if (wait_for((I915_READ(stat_reg) & PP_ON) == 0, 1000))
         DRM_ERROR("timed out waiting for panel to power off\n");


This patch is against 3.1 rc8 with Keith Packard's drm-intel-fixes merged in.

Putting printk's in ./drivers/gpu/drm/i915/intel_panel.c showed that intel_get_brightness was being called after 

the panel was disabled, which caused a 0 to be saved as the value to restore the brightness. intel_panel_disable_backlight
merely sets the brightness to 0. Commenting out this call allows the correct brightness value to be saved.

Thoughts?
