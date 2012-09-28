Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2I1M4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:56:16 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51438 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab2I1M4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:56:11 -0400
MIME-Version: 1.0
In-Reply-To: <201209281452.22871.hverkuil@xs4all.nl>
References: <1344429020-27616-1-git-send-email-prabhakar.lad@ti.com>
 <1344429020-27616-2-git-send-email-prabhakar.lad@ti.com> <CA+V-a8tPQsc4-gS7jDCNy5PmsbTafoER9aXeL39_45Tk=0MjSw@mail.gmail.com>
 <201209281452.22871.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 28 Sep 2012 18:25:50 +0530
Message-ID: <CA+V-a8vVLyrDdR4NMMq17orb-dvFwsjT_2GeRygqcW-bYZnsjw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dm644x: replace the obsolete preset API by the
 timings API.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kevin Hilman <khilman@ti.com>, LMML <linux-media@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>, Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Fri, Sep 28, 2012 at 6:22 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar!
>
> On Fri September 28 2012 14:44:59 Prabhakar Lad wrote:
>> Hi Kevin,
>>
>> On Wed, Aug 8, 2012 at 6:00 PM, Prabhakar Lad <prabhakar.lad@ti.com> wrote:
>> > From: Hans Verkuil <hans.verkuil@cisco.com>
>> >
>> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> > ---
>> >  arch/arm/mach-davinci/board-dm644x-evm.c   |   15 ++--
>> >  arch/arm/mach-davinci/dm644x.c             |   17 +---
>> >  drivers/media/video/davinci/vpbe.c         |  110 ++++++++++++----------------
>> >  drivers/media/video/davinci/vpbe_display.c |   60 +++++++--------
>> >  drivers/media/video/davinci/vpbe_venc.c    |   25 +++---
>> >  include/media/davinci/vpbe.h               |   14 ++--
>> >  include/media/davinci/vpbe_types.h         |    8 +--
>> >  include/media/davinci/vpbe_venc.h          |    2 +-
>> >  8 files changed, 111 insertions(+), 140 deletions(-)
>> >
>> Can you ACK this patch? Since this patch needs to go from Mauro's tree
>> due to changes in media drivers folder structure.
>>
>> Regards,
>> --Prabhakar Lad
>>
>
> ...
>
>> > -static int vpbe_s_dv_preset(struct vpbe_device *vpbe_dev,
>> > -                    struct v4l2_dv_preset *dv_preset)
>> > +static int vpbe_s_dv_timings(struct vpbe_device *vpbe_dev,
>> > +                    struct v4l2_dv_timings *dv_timings)
>> >  {
>> >         struct vpbe_config *cfg = vpbe_dev->cfg;
>> >         int out_index = vpbe_dev->current_out_index;
>> > +       struct vpbe_output *output = &cfg->outputs[out_index];
>> >         int sd_index = vpbe_dev->current_sd_index;
>> > -       int ret;
>> > +       int ret, i;
>> >
>> >
>> >         if (!(cfg->outputs[out_index].output.capabilities &
>> > -           V4L2_OUT_CAP_PRESETS))
>> > +           V4L2_OUT_CAP_CUSTOM_TIMINGS))
>
> Can you make a follow-up patch that renames V4L2_IN/OUT_CAP_CUSTOM_TIMINGS to
> V4L2_IN/OUT_CAP_DV_TIMINGS? The old name for this define is deprecated, so it
> would be nice to fix this in this driver as well.
>
> The code that adds the new define names went in just two days ago, so as far
> as I am concerned there is no need to modify the patch again. A follow-up
> patch is sufficient.
>
Ok, I'll create a follow up patch.

Regards,
--Prabhakar

> Regards,
>
>         Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
