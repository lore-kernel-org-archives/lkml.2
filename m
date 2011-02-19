Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1BSCWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 21:22:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35598 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1BSCWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 21:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jRjI0brYeMLSyQkNbK8glsGkz4i5QwZj8Lq9bDQOVvlIuFQOxWdFUYYDGDLJmoDv58
         oIhUqdxtHVMF8SlgjL5ioBNhZWMjKLQqu6b/Rujqy19n/wWj2VHZ4MA1WWxN5Xl6UMBM
         1c1cFliNPUwrjKI32tB5mKk1WKc2SrWNo0kC4=
MIME-Version: 1.0
In-Reply-To: <20110218095221.GK24426@pengutronix.de>
References: <1297865452-32181-1-git-send-email-s.hauer@pengutronix.de>
	<1297865452-32181-4-git-send-email-s.hauer@pengutronix.de>
	<AANLkTina46_CMvB_9cqc4=PvcPxaV_BQ_H_ghJZFFxg8@mail.gmail.com>
	<20110218095221.GK24426@pengutronix.de>
Date: Sat, 19 Feb 2011 10:22:08 +0800
Message-ID: <AANLkTi=hm41HUtwXJSdfGtjj2pRo1xAv1AmZ5zaTp5Sj@mail.gmail.com>
Subject: Re: [PATCH 3/7] Add i.MX5 framebuffer driver
From: Jason Chen <weitway@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Sascha,

2011/2/18 Sascha Hauer <s.hauer@pengutronix.de>:
> Hi Jason,
>
> On Fri, Feb 18, 2011 at 05:22:09PM +0800, Jason Chen wrote:
>> hi, Sasha,
>>
>> > +       if (var->vmode & FB_VMODE_ODD_FLD_FIRST) /* PAL */
>> > +               sig_cfg.odd_field_first = 1;
>> > +       if (var->sync & FB_SYNC_EXT)
>> > +               sig_cfg.ext_clk = 1;
>> > +       if (var->sync & FB_SYNC_HOR_HIGH_ACT)
>> > +               sig_cfg.Hsync_pol = 1;
>> Please remove FB_SYNC_EXT support.
>
> No problem, can do. But why? Is it nonfunctional in the hardware
> or is it that the current code just misses more pieces to support
> this?
>
This flag represents external sync, some application will not check
this flag when they reset fb var, for example, X server fb driver will
ignore it, if so, the ipu external clock can not be set correctly.
I think ipu should decide external clock usage by other method. The
latest method in freesacle mainline is decide it automatically -- if
internal clock can not fit target clock rate well, switch it to
external.
>>
>> +static void imx_ipu_fb_disable_overlay(struct fb_info *ovl)
>> +{
>> +       struct imx_ipu_fb_info *mxc_ovl = ovl->par;
>> +
>> +       if (!mxc_ovl->enabled)
>> +               return;
>> +
>> +       ipu_dp_disable_fg(mxc_ovl->dp);
>> +       ipu_wait_for_interrupt(451, 100);
>> +       ipu_idmac_disable_channel(mxc_ovl->ipu_ch);
>> +       ipu_dmfc_disable_channel(mxc_ovl->dmfc);
>> +       mxc_ovl->enabled = 0;
>> +}
>> Had better has a definition of ipu irq 451.
>
> Ok.
>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>
