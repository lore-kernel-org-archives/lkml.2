Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab2IGTKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:10:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39083 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2IGTKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:10:11 -0400
MIME-Version: 1.0
In-Reply-To: <504A3B03.4090600@iki.fi>
References: <1347007309-6913-1-git-send-email-prabhakar.lad@ti.com> <504A3B03.4090600@iki.fi>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 8 Sep 2012 00:39:50 +0530
Message-ID: <CA+V-a8vu+Zv6u5Pp_f8qYthpyAWOGgfuOfXwjxoEJwJE8aQuEQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: v4l2-ctrls: add control for test pattern
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the review.

On Fri, Sep 7, 2012 at 11:50 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Prabhakar,
>
> Thanks for the patch!
>
>
> Prabhakar Lad wrote:
>>
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> add V4L2_CID_TEST_PATTERN of type menu, which determines
>> the internal test pattern selected by the device.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Rob Landley <rob@landley.net>
>> ---
>> This patches has one checkpatch warning for line over
>> 80 characters altough it can be avoided I have kept it
>> for consistency.
>>
>> Changes for v2:
>> 1: Included display devices in the description for test pattern
>>     as pointed by Hans.
>> 2: In the menu replaced 'Test Pattern Disabled' by 'Disabled' as
>>     pointed by Sylwester.
>> 3: Removed the test patterns from menu as the are hardware specific
>>     as pointed by Sakari.
>>
>>   Documentation/DocBook/media/v4l/controls.xml |   20 ++++++++++++++++++++
>>   drivers/media/v4l2-core/v4l2-ctrls.c         |    8 ++++++++
>>   include/linux/videodev2.h                    |    4 ++++
>>   3 files changed, 32 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>> b/Documentation/DocBook/media/v4l/controls.xml
>> index ad873ea..173934e 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -4311,6 +4311,26 @@ interface and may change in the future.</para>
>>               </tbody>
>>             </entrytbl>
>>           </row>
>> +         <row>
>> +           <entry
>> spanname="id"><constant>V4L2_CID_TEST_PATTERN</constant></entry>
>> +           <entry>menu</entry>
>> +         </row>
>> +         <row id="v4l2-test-pattern">
>> +           <entry spanname="descr"> The Capture/Display/Sensors have the
>> capability
>> +           to generate internal test patterns and this are hardware
>> specific. This
>> +           test patterns are used to test a device is properly working
>> and can generate
>> +           the desired waveforms that it supports.</entry>
>> +         </row>
>> +         <row>
>> +           <entrytbl spanname="descr" cols="2">
>> +             <tbody valign="top">
>> +               <row>
>> +
>> <entry><constant>V4L2_TEST_PATTERN_DISABLED</constant></entry>
>> +                 <entry>Test pattern generation is disabled</entry>
>> +               </row>
>> +             </tbody>
>> +           </entrytbl>
>> +         </row>
>>         <row><entry></entry></row>
>>         </tbody>
>>         </tgroup>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
>> b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 8f2f40b..d731422 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -430,6 +430,10 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>                 "Advanced",
>>                 NULL,
>>         };
>> +       static const char * const test_pattern[] = {
>> +               "Disabled",
>> +               NULL,
>> +       };
>>
>>         switch (id) {
>>         case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
>> @@ -509,6 +513,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>                 return jpeg_chroma_subsampling;
>>         case V4L2_CID_DPCM_PREDICTOR:
>>                 return dpcm_predictor;
>> +       case V4L2_CID_TEST_PATTERN:
>> +               return test_pattern;
>
>
> I think it's not necessary to define test_pattern (nor be prepared to return
> it) since the menu is going to be device specific. So the driver is
> responsible for all of the menu items. Such menus are created using
> v4l2_ctrl_new_custom() instead of v4l2_ctrl_new_std_menu().
>
Ok.

Regrads,
--Prabhakar Lad

> Looks good to me otherwise.
>
> Kind regards,
>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
