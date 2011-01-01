Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1AANqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 08:46:31 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53320 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1AANqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 08:46:30 -0500
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@md.metrocast.net>, Andy Walls <awalls@radix.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 14/18] cx25840: Fix subdev registration in cx25840-core.c
Date: Sat, 1 Jan 2011 15:44:40 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-smp+; KDE/4.4.3; i686; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ivtv-devel@ivtvdriver.org
References: <v38khxmtvlbmmvf5dv0i04b4.1293886218059@email.android.com>
In-Reply-To: <v38khxmtvlbmmvf5dv0i04b4.1293886218059@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101011544.40967.liplianin@me.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В сообщении от 1 января 2011 14:58:30 автор Andy Walls написал:
> Igor,
> 
> The proper fix is here:
> 
> https://patchwork.kernel.org/patch/376612/
> 
> So, NAK on your particular patch.
So, it is safe to skip my patch.
Mauro, please skip it.

> 
> Mauro,
> 
> I do not see the above patch at linux next.  And I couldn't find it in your
> kernel.org tree.  What is its status?
> 
> This fixes a regression that is known to break cx23885 hardware
> initialization and can break ivtv hardware initialization.
> 
> Regards,
> Andy
> 
> "Igor M. Liplianin" <liplianin@me.by> wrote:
> >On my system, cx23885 based card reports default volume value above 70000.
> >So, register cx25840 subdev fails. Although, the card don't have a/v
> >inputs it needs a/v firmware to be loaded.
> >
> >Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
> >---
> >
> > drivers/media/video/cx25840/cx25840-core.c |    2 ++
> > 1 files changed, 2 insertions(+), 0 deletions(-)
> >
> >diff --git a/drivers/media/video/cx25840/cx25840-core.c
> >b/drivers/media/video/cx25840/cx25840-core.c index dfb198d..dc0cec7
> >100644
> >--- a/drivers/media/video/cx25840/cx25840-core.c
> >+++ b/drivers/media/video/cx25840/cx25840-core.c
> >@@ -1991,6 +1991,8 @@ static int cx25840_probe(struct i2c_client *client,
> >
> > 	if (!is_cx2583x(state)) {
> > 	
> > 		default_volume = 228 - cx25840_read(client, 0x8d4);
> > 		default_volume = ((default_volume / 2) + 23) << 9;
> >
> >+		if (default_volume > 65535)
> >+			default_volume = 65535;
> >
> > 		state->volume = v4l2_ctrl_new_std(&state->hdl,
> > 		
> > 			&cx25840_audio_ctrl_ops, V4L2_CID_AUDIO_VOLUME,

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
