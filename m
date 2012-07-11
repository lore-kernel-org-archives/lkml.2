Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab2GKOGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:06:06 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:58249 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab2GKOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:06:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIFAISH/U+Q/khL/2dsb2JhbABFtASDWoEHgiABAQEDARIBFFIFCwsYLlcGNYdlBp08oBmLQIVuA4gWjSSOIIFmgmE
X-IronPort-AV: E=Sophos;i="4.77,567,1336348800"; 
   d="scan'208";a="140994704"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH RFC] [media] adv7180.c: convert to v4l2 control framework
Date: Wed, 11 Jul 2012 16:05:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.3-0.slh.4-aptosid-amd64; KDE/4.7.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1341974086-27887-1-git-send-email-federico.vaga@gmail.com> <201207110834.53760.hverkuil@xs4all.nl> <1460334.RCi3doz24X@harkonnen>
In-Reply-To: <1460334.RCi3doz24X@harkonnen>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111605.49470.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11 July 2012 15:36:25 Federico Vaga wrote:
> Hi Hans,
> 
> Thank you for your review
> 
> > > +static int adv7180_init_controls(struct adv7180_state *state)
> > > +{
> > > +	v4l2_ctrl_handler_init(&state->ctrl_hdl, 2);
> > 
> > 2 -> 4, since there are 4 controls. It's a hint only, but it helps
> > optimizing the internal hash data structure.
> 
> Sure :)
> 
> > > 
> > > @@ -445,9 +402,9 @@ static const struct v4l2_subdev_video_ops
> > > adv7180_video_ops = {> 
> > >  static const struct v4l2_subdev_core_ops adv7180_core_ops = {
> > >  
> > >  	.g_chip_ident = adv7180_g_chip_ident,
> > >  	.s_std = adv7180_s_std,
> > > 
> > > -	.queryctrl = adv7180_queryctrl,
> > > -	.g_ctrl = adv7180_g_ctrl,
> > > -	.s_ctrl = adv7180_s_ctrl,
> > > +	.queryctrl = v4l2_subdev_queryctrl,
> > > +	.g_ctrl = v4l2_subdev_g_ctrl,
> > > +	.s_ctrl = v4l2_subdev_s_ctrl,
> > 
> > If adv7180 is currently *only* used by bridge/platform drivers that
> > also use the control framework, then you can remove
> > queryctrl/g/s_ctrl altogether.
> 
> I'm not sure to undestand this point. I "grepped" for the adv7180 and it 
> seem that I'm the only user of the adv7180 (sta2x11 VIP driver). In the
> VIP driver I don't use the control framework (there aren't controls), so 
> I think these lines must be there. Am I wrong?

Correct. But once sta2x11 is converted to using the control framework, then
these lines can be dropped since no one else is using this subdevice driver.

> I think you are thinking at the "Inheriting Controls" section of the 
> v4l2-controls.txt document. Right?

Right.

Regards,

	Hans

> 
> 
> > > -	ret = i2c_smbus_write_byte_data(client, ADV7180_HUE_REG,
> > > state->hue); +	ret = i2c_smbus_write_byte_data(client,
> > > ADV7180_HUE_REG,
> > > +					ADV7180_HUE_DEF);
> > 
> > It shouldn't be necessary to initialize the controls since
> > v4l2_ctrl_handler_setup does that for you already.
> 
> Removed
> 
> 
