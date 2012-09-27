Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2I0FWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:22:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45073 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2I0FWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:22:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120926170737.5979b1e8@infradead.org>
References: <1345125720-24059-1-git-send-email-prabhakar.lad@ti.com> <20120926170737.5979b1e8@infradead.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 27 Sep 2012 10:51:48 +0530
Message-ID: <CA+V-a8v-7uMDxYLgH4FrbNrQwYq=8=yODDibhd7J7ix4vExdhQ@mail.gmail.com>
Subject: Re: [PATCH] media: davinci: vpif: add check for NULL handler
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>, LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Thu, Sep 27, 2012 at 1:37 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em Thu, 16 Aug 2012 19:32:00 +0530
> Prabhakar Lad <prabhakar.lad@ti.com> escreveu:
>
> It is amazing how many SOB's/acks are in this patch and nobody
> asked you to provide a patch description... the subject just
> tells what the code is also telling. Could you please provide
> a better patch description?
>
My bad I'll post a v2.

Regards,
--Prabhakar Lad

> Thanks!
> Mauro
>
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/video/davinci/vpif_capture.c |   12 +++++++-----
>>  drivers/media/video/davinci/vpif_display.c |   14 ++++++++------
>>  2 files changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
>> index 266025e..a87b7a5 100644
>> --- a/drivers/media/video/davinci/vpif_capture.c
>> +++ b/drivers/media/video/davinci/vpif_capture.c
>> @@ -311,12 +311,14 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>>       }
>>
>>       /* configure 1 or 2 channel mode */
>> -     ret = vpif_config_data->setup_input_channel_mode
>> -                                     (vpif->std_info.ycmux_mode);
>> +     if (vpif_config_data->setup_input_channel_mode) {
>> +             ret = vpif_config_data->setup_input_channel_mode
>> +                                             (vpif->std_info.ycmux_mode);
>>
>> -     if (ret < 0) {
>> -             vpif_dbg(1, debug, "can't set vpif channel mode\n");
>> -             return ret;
>> +             if (ret < 0) {
>> +                     vpif_dbg(1, debug, "can't set vpif channel mode\n");
>> +                     return ret;
>> +             }
>>       }
>>
>>       /* Call vpif_set_params function to set the parameters and addresses */
>> diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
>> index e129c98..1e35f92 100644
>> --- a/drivers/media/video/davinci/vpif_display.c
>> +++ b/drivers/media/video/davinci/vpif_display.c
>> @@ -280,12 +280,14 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>>       }
>>
>>       /* clock settings */
>> -     ret =
>> -         vpif_config_data->set_clock(ch->vpifparams.std_info.ycmux_mode,
>> -                                     ch->vpifparams.std_info.hd_sd);
>> -     if (ret < 0) {
>> -             vpif_err("can't set clock\n");
>> -             return ret;
>> +     if (vpif_config_data->set_clock) {
>> +             ret =
>> +             vpif_config_data->set_clock(ch->vpifparams.std_info.ycmux_mode,
>> +                                             ch->vpifparams.std_info.hd_sd);
>> +             if (ret < 0) {
>> +                     vpif_err("can't set clock\n");
>> +                     return ret;
>> +             }
>>       }
>>
>>       /* set the parameters and addresses */
>
>
>
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
