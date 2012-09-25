Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2IYFlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 01:41:35 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38303 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2IYFld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 01:41:33 -0400
MIME-Version: 1.0
In-Reply-To: <201209241537.17549.hverkuil@xs4all.nl>
References: <1348491221-6068-1-git-send-email-prabhakar.lad@ti.com>
 <1348491221-6068-2-git-send-email-prabhakar.lad@ti.com> <201209241537.17549.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 25 Sep 2012 11:11:12 +0530
Message-ID: <CA+V-a8u-iXiMvD7EpfVjNXw-J-pkp477ZK+brSE_GaKe-hF8DA@mail.gmail.com>
Subject: Re: [PATCH v3] media: v4l2-ctrls: add control for test pattern
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        LMML <linux-media@vger.kernel.org>, Rob Landley <rob@landley.net>,
        LDOC <linux-doc@vger.kernel.org>, VGER <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review,

On Mon, Sep 24, 2012 at 7:07 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Mon September 24 2012 14:53:41 Prabhakar wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> add V4L2_CID_TEST_PATTERN of type menu, which determines
>> the internal test pattern selected by the device.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Rob Landley <rob@landley.net>
>> ---
>>  This patches has one checkpatch warning for line over
>>  80 characters altough it can be avoided I have kept it
>>  for consistency.
>>
>>  Changes for v3:
>>  1: Removed the menu for test pattern, pointed by Sakari.
>>
>>  Changes for v2:
>>  1: Included display devices in the description for test pattern
>>    as pointed by Hans.
>>  2: In the menu replaced 'Test Pattern Disabled' by 'Disabled' as
>>    pointed by Sylwester.
>>  3: Removed the test patterns from menu as the are hardware specific
>>    as pointed by Sakari.
>>
>>  Documentation/DocBook/media/v4l/controls.xml |   10 ++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c         |    2 ++
>>  include/linux/videodev2.h                    |    1 +
>>  3 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index f0fb08d..51e9c4e 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -4313,6 +4313,16 @@ interface and may change in the future.</para>
>>             </tbody>
>>           </entrytbl>
>>         </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_TEST_PATTERN</constant></entry>
>> +         <entry>menu</entry>
>> +       </row>
>> +       <row id="v4l2-test-pattern">
>> +         <entry spanname="descr"> The Capture/Display/Sensors have the capability
>> +         to generate internal test patterns and this are hardware specific. This
>> +         test patterns are used to test a device is properly working and can generate
>> +         the desired waveforms that it supports.</entry>
>
> Some grammar/style fixes:
>
>             <entry spanname="descr"> Some capture/display/sensor devices have the
>             capability to generate test pattern images. These hardware specific
>             test patterns can be used to test if a device is working properly.</entry>
>
I'll fix it in next version.

Regards,
--Prabhakar Lad

>
>> +       </row>
>>       <row><entry></entry></row>
>>       </tbody>
>>        </tgroup>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 8f2f40b..41b7732 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -740,6 +740,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>       case V4L2_CID_LINK_FREQ:                return "Link Frequency";
>>       case V4L2_CID_PIXEL_RATE:               return "Pixel Rate";
>>       case V4L2_CID_DPCM_PREDICTOR:           return "DPCM Predictor";
>> +     case V4L2_CID_TEST_PATTERN:             return "Test Pattern";
>>
>>       default:
>>               return NULL;
>> @@ -841,6 +842,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>>       case V4L2_CID_EXPOSURE_METERING:
>>       case V4L2_CID_SCENE_MODE:
>>       case V4L2_CID_DPCM_PREDICTOR:
>> +     case V4L2_CID_TEST_PATTERN:
>>               *type = V4L2_CTRL_TYPE_MENU;
>>               break;
>>       case V4L2_CID_LINK_FREQ:
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index ca9fb78..7014c0b 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -2005,6 +2005,7 @@ enum v4l2_dpcm_predictor {
>>       V4L2_DPCM_PREDICTOR_SIMPLE      = 0,
>>       V4L2_DPCM_PREDICTOR_ADVANCED    = 1,
>>  };
>> +#define V4L2_CID_TEST_PATTERN                        (V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
>>
>>  /*
>>   *   T U N I N G
>>
>
> Regards,
>
>         Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
