Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab2GKOWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:22:13 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:23923 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab2GKOWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:22:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEFAP+K/U+Q/khM/2dsb2JhbABFtASDWoEHgiABAQEEEgFmEAsYLlcGNYdrnUOgG4tAhW4DiBaNJI4ggWaCYQ
X-IronPort-AV: E=Sophos;i="4.77,567,1336348800"; 
   d="scan'208";a="140995789"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH RFC] [media] adv7180.c: convert to v4l2 control framework
Date: Wed, 11 Jul 2012 16:21:56 +0200
User-Agent: KMail/1.13.7 (Linux/3.3-0.slh.4-aptosid-amd64; KDE/4.7.4; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1341974086-27887-1-git-send-email-federico.vaga@gmail.com> <201207111605.49470.hverkuil@xs4all.nl> <1764384.YhnDdKNyk4@harkonnen>
In-Reply-To: <1764384.YhnDdKNyk4@harkonnen>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111621.57058.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11 July 2012 16:19:02 Federico Vaga wrote:
> > > > @@ -445,9 +402,9 @@ static const struct v4l2_subdev_video_ops
> > > > adv7180_video_ops = {> 
> > > >  static const struct v4l2_subdev_core_ops adv7180_core_ops = {
> > > >  
> > > >   .g_chip_ident = adv7180_g_chip_ident,
> > > >   .s_std = adv7180_s_std,
> > > > 
> > > > - .queryctrl = adv7180_queryctrl,
> > > > - .g_ctrl = adv7180_g_ctrl,
> > > > - .s_ctrl = adv7180_s_ctrl,
> > > > + .queryctrl = v4l2_subdev_queryctrl,
> > > > + .g_ctrl = v4l2_subdev_g_ctrl,
> > > > + .s_ctrl = v4l2_subdev_s_ctrl,
> > > 
> > > I'm not sure to undestand this point. I "grepped" for the adv7180
> > > and it seem that I'm the only user of the adv7180 (sta2x11 VIP
> > > driver). In the VIP driver I don't use the control framework (there
> > > aren't controls), so I think these lines must be there. Am I wrong?
> > 
> > Correct. But once sta2x11 is converted to using the control framework,
> > then these lines can be dropped since no one else is using this
> > subdevice driver.
> 
> What do you suggest? I re-submit this patch and when sta2x11 is fixed a 
> I submit a new patch to remove these lines; or wait the full conversion 
> of the sta2x11 driver and submit both patch?

Choice 1: when sta2x11 is fixed submit a new patch to remove those lines.

Regards,

	Hans
