Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1JaXl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:41:26 -0400
Received: from nm15-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.208]:43136 "HELO
	nm15-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751669Ab1JaXlZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:41:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 972500.94412.bm@omp1018.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zC2asFAgQKU16XNwq+4tSovVbgLKZ1OdnZEJjHN3LKbTq/aohKM4S6GcafCGiHjXieSQrTwZmg0+WxnU+sGpB3fVRZHJbbiThJRZqFh3t8FToO2Y9VB17qhsQqAIxrlWs3QPqMZIvHihCvTnj8vfHYHinC/sXAEpKwD4jhKIN6g=;
X-YMail-OSG: v7AePDwVM1m7WPX45g9MK5Q1pT5Y8W4OUq878T9GwviFn2e
 54Lg-
X-Mailer: YahooMailWebService/0.8.115.325013
References: <1319743670.62757.YahooMailNeo@web130109.mail.mud.yahoo.com> <1319747904.1731.YahooMailNeo@web130113.mail.mud.yahoo.com> <4EAEA93A.9010100@science.uva.nl>
Message-ID: <1320104484.55688.YahooMailNeo@web130114.mail.mud.yahoo.com>
Date: Mon, 31 Oct 2011 16:41:24 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [bisected] i915 dpms does not switch back light on
To: "Wouter M. Koolen" <wmkoolen@science.uva.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4EAEA93A.9010100@science.uva.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
>> index 6f56676..a9e0c7b 100644
>> --- a/drivers/gpu/drm/i915/intel_panel.c
>> +++ b/drivers/gpu/drm/i915/intel_panel.c
>> @@ -262,6 +262,8 @@ void intel_panel_disable_backlight(struct drm_device *dev)
>>                  dev_priv->backlight_level = intel_panel_get_backlight(dev);
>>                  dev_priv->backlight_enabled = false;
>>          }
>> +
>> +       intel_panel_set_backlight(dev, 0);
>>   }
>>     void intel_panel_enable_backlight(struct drm_device *dev)
>Hi Alex,
>
>That indeed solves the problem here.
>
>Thanks for your swift response.
>
>Wouter

Actually, I sent you the wrong patch: the patch was supposed to remove those lines, not add them. 

