Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935284Ab1JET7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:59:42 -0400
Received: from nm34-vm4.bullet.mail.ne1.yahoo.com ([98.138.229.84]:24707 "HELO
	nm34-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934378Ab1JET7l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:59:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 934810.33395.bm@omp1038.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Z50mQVD2ymIxptLRUmwKSzz8Eye27cLIvxH5WiTMV0yMgkAUxZ8Mw2lN+RmqFLh+4y935QucLhTdHU8LtvmgM4mmi4ftfhv0G9/hdOxThLCstIfgOA5+fBcUR8JEstReJ7nxlyDDjUZdv3bb0Nw7IGJw4YmPtQMwVB40P0tUmu0=;
X-YMail-OSG: OUegb8IVM1k0uLSIoo1R4CNjrQeaBWT267WfnL2YPMBtNEr
 3OXg0cVIGvJ1ygNheRYgOCIDCuHY12mgFaDgbrl_qU1Uh_zWu59np8zJ5hWm
 hs.O5V6A7Dr14RdvM2CsteSd3U9LI07PWEQZ_CkVntr1f3L6s45bx8nWI1JO
 qrA70.EhTnHEP9fc4fBf1E6vzDvyGwCQtMasQKZ11lEOVgTyMK.H9tS7d.Sd
 hKpHOLss_nGd00_e6fi8kKhbeOFB8nYJPg0szrDViCSYgKG5JzPDzHeoT92d
 SkgZZHN0yUKn91fI0iAdX5y6ui.wsTywo2E3zeiF4SUH_OWqrF6IrQ.DtHHU
 ATVmqW8rDdx1FKmvaJeem7ZI6bS4d1IogqlKSM_YHiRi_dySR.wUfJa_.NzL
 7GB65ZKmerFd1gYb0a4UR5ah8f_BFnFCK6u.5Y_w__MzPvIY6uCwOrMCn43Y
 t3H_yb6ONkOjX3nLX3x9zXvF.TA--
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316957834.67111.YahooMailNeo@web130112.mail.mud.yahoo.com> <1317676210.22894.YahooMailNeo@web130106.mail.mud.yahoo.com> <yun1uuslfhg.fsf@aiko.keithp.com>
Message-ID: <1317844780.69103.YahooMailNeo@web130122.mail.mud.yahoo.com>
Date: Wed, 5 Oct 2011 12:59:40 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re:  Regression: i915 blank issue on kernel 3.1.0-rc3
To: Keith Packard <keithp@keithp.com>,
        "terraluna977@gmail.com" <terraluna977@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <yun1uuslfhg.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.From: Keith Packard <keithp@keithp.com>
>> The following patch fixed my backlight issues:
>> 
>> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
>> index a9e0c7b..6f56676 100644
>> --- a/drivers/gpu/drm/i915/intel_panel.c
>> +++ b/drivers/gpu/drm/i915/intel_panel.c
>> @@ -262,8 +262,6 @@ void intel_panel_disable_backlight(struct drm_device *dev)
>>          dev_priv->backlight_level = intel_panel_get_backlight(dev);
>>          dev_priv->backlight_enabled = false;
>>      }
>> -
>> -    intel_panel_set_backlight(dev, 0);
>>  }
>>  
>>  void intel_panel_enable_backlight(struct drm_device *dev)
>> 
>> I've been using it since yesterday morning with no issues.
>
>Matthew -- if we cannot resolve this backlight issue, we're going to
>need to disable the new backlight code for 3.1. Do you want to try and
>fix it? Or should we bail for now?

By 'disable', do you mean revert? If so, I would the like chance to submit a patch that adds a boot parameter 
for the driver to disable the backlight by default, e.g: i915_disable_bl. Once the issues are sorted, the
parameter could be removed.
