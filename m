Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1HVE2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 00:28:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56694 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1HVE2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 00:28:30 -0400
Date: Sun, 21 Aug 2011 21:28:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: chase.douglas@canonical.com, rydberg@euromail.se,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Subject: Re: [PATCH 4/9 v4] Input: synaptics - add image sensor support
Message-ID: <20110822042822.GA23010@core.coreip.homeip.net>
References: <1313666888-18939-1-git-send-email-djkurtz@chromium.org>
 <1313666888-18939-5-git-send-email-djkurtz@chromium.org>
 <20110819222203.GC5146@core.coreip.homeip.net>
 <CAGS+omCZSjJoESSvimLEpj9Mwr3d9Vn78e1ZLk-NWEdgQbxNKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omCZSjJoESSvimLEpj9Mwr3d9Vn78e1ZLk-NWEdgQbxNKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 03:07:41PM +0800, Daniel Kurtz wrote:
> On Sat, Aug 20, 2011 at 6:22 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Daniel,
> >
> > On Thu, Aug 18, 2011 at 07:28:03PM +0800, Daniel Kurtz wrote:
> >> @@ -558,6 +626,11 @@ static void synaptics_process_packet(struct psmouse *psmouse)
> >>       if (synaptics_parse_hw_state(psmouse->packet, priv, &hw))
> >>               return;
> >>
> >> +     if (SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)) {
> >> +             synaptics_image_sensor_process(psmouse, &hw);
> >> +             return;
> >> +     }
> >> +
> >
> > So what about the rest of the SYnaptics processing (wheel, additional
> > buttons, etc)?  Are we sure that touchpads with image sensors will never
> > implement them?
> >
> > --
> > Dmitry
> >
> 
> All image sensors that I am aware of are clickpads, with one button
> integrated under the pad, which is reported as the middle button.
> 
> We could report right, middle, up, down, and ext_buttons (scroll is
> not possible, since w=2;buf[1] is used for x for devices that send agm
> packets).
> However, I have no way of knowing if this added complexity is
> necessary

I would prefer us supporting full protocol so if some vendor does add
additional buttons we have everything in place.

> , nor any way of testing it.

As long as your case still works I think it will be good enough.

Thanks.

-- 
Dmitry
