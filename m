Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab2GKOPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:15:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50847 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab2GKOPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:15:30 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [media] adv7180.c: convert to v4l2 control framework
Date: Wed, 11 Jul 2012 16:19:02 +0200
Message-ID: <1764384.YhnDdKNyk4@harkonnen>
User-Agent: KMail/4.8.4 (Linux/3.4.4-5.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <201207111605.49470.hverkuil@xs4all.nl>
References: <1341974086-27887-1-git-send-email-federico.vaga@gmail.com> <1460334.RCi3doz24X@harkonnen> <201207111605.49470.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > @@ -445,9 +402,9 @@ static const struct v4l2_subdev_video_ops
> > > adv7180_video_ops = {> 
> > >  static const struct v4l2_subdev_core_ops adv7180_core_ops = {
> > >  
> > >   .g_chip_ident = adv7180_g_chip_ident,
> > >   .s_std = adv7180_s_std,
> > > 
> > > - .queryctrl = adv7180_queryctrl,
> > > - .g_ctrl = adv7180_g_ctrl,
> > > - .s_ctrl = adv7180_s_ctrl,
> > > + .queryctrl = v4l2_subdev_queryctrl,
> > > + .g_ctrl = v4l2_subdev_g_ctrl,
> > > + .s_ctrl = v4l2_subdev_s_ctrl,
> > 
> > I'm not sure to undestand this point. I "grepped" for the adv7180
> > and it seem that I'm the only user of the adv7180 (sta2x11 VIP
> > driver). In the VIP driver I don't use the control framework (there
> > aren't controls), so I think these lines must be there. Am I wrong?
> 
> Correct. But once sta2x11 is converted to using the control framework,
> then these lines can be dropped since no one else is using this
> subdevice driver.

What do you suggest? I re-submit this patch and when sta2x11 is fixed a 
I submit a new patch to remove these lines; or wait the full conversion 
of the sta2x11 driver and submit both patch?

-- 
Federico Vaga
