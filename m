Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1J0Ui0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:38:26 -0400
Received: from nm17.bullet.mail.sp2.yahoo.com ([98.139.91.87]:26363 "HELO
	nm17.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753516Ab1J0UiZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:38:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 822025.8604.bm@omp1042.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=WMkeGpGWG/FVaVDYq4yqlL5ShjGcC6G0EYrKOHvgWxHhBWFllth+BnegRi5nDSAs0u6K5o3jgPcv3k1iI3nfG0pAasElreAZrUkCAfBIuM3FAqlxKujsiYbQKF8KKzPpd8yAPKv8kv7cEpC0v019KPPhcU+IpD4cmYw51HUxAWw=;
X-YMail-OSG: IQZbJw4VM1m5s9ZK55D5Esv2tTbyaVLi1zkTEx8m0_w9RGa
 DEdt11QIzBXCnYr96hZsqvVuuy6t4fZdXgMQJW2di9q_TMdow.gIbmYq5Q4n
 2Chuk6j.ZKOTW8D9MhdLpG4ZV0Anet6LEPQGQr91rqLR3Mlh6VCwXNRi2yQz
 9cWjftyavWSXqpYH1SCDoL_iq.D5Xi_OfO8vWal1RgyMaCfQbjJrybc3WE7L
 yDbNC.5KSJWDdLHt0L9313NjgdRcdo_HZi9.2fsUc0BLI2DhN_6YhW.PlWXz
 Ire9L._9zGq5.5vVaLeeNgWWzjFqeCapD8QhEI_o0WDTj4ZMyQrTpYjkTyk.
 _FUDuYrg8uVxrq4diSyZ_vhwnpC2SZoFQ059TXwze.q0fUGP3nThuZqEhDa4
 sqqVwoZWexpnjAAQHRgHsWt9_NXLuoDtTJrFT.FY72ODH4I1qmShXEH8e3lL
 tGOwOra5Z.F93RiUfK2RoDzj2iw--
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1319743670.62757.YahooMailNeo@web130109.mail.mud.yahoo.com>
Message-ID: <1319747904.1731.YahooMailNeo@web130113.mail.mud.yahoo.com>
Date: Thu, 27 Oct 2011 13:38:24 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [bisected] i915 dpms does not switch back light on
To: "wmkoolen@science.uva.nl" <wmkoolen@science.uva.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1319743670.62757.YahooMailNeo@web130109.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>I've been having this problem as well. I created a patch that fixes the problem for me and others:
>
>diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
>index 6f56676..a9e0c7b 100644
>--- a/drivers/gpu/drm/i915/intel_panel.c
>+++ b/drivers/gpu/drm/i915/intel_panel.c
>@@ -262,6 +262,8 @@ void intel_panel_disable_backlight(struct drm_device *dev)
>                dev_priv->backlight_level = intel_panel_get_backlight(dev);
>                dev_priv->backlight_enabled = false;
>        }
>+
>+       intel_panel_set_backlight(dev, 0);
> }
>

If the patch above doesn't work, try this one:

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 6f56676..a9e0c7b 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -262,6 +262,8 @@ void intel_panel_disable_backlight(struct drm_device *dev)
                dev_priv->backlight_level = intel_panel_get_backlight(dev);
                dev_priv->backlight_enabled = false;
        }
+
+       intel_panel_set_backlight(dev, 0);
 }
 
 void intel_panel_enable_backlight(struct drm_device *dev)
