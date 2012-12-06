Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2LFEyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 23:54:41 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56654 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2LFEyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 23:54:39 -0500
MIME-Version: 1.0
In-Reply-To: <201212051308.34309.hverkuil@xs4all.nl>
References: <1354708169-1139-1-git-send-email-prabhakar.csengg@gmail.com> <201212051308.34309.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 6 Dec 2012 10:24:18 +0530
Message-ID: <CA+V-a8t+KxCYunkrT715zQks=5HOrFk2PSM2Ss_kTj4iXg=PJg@mail.gmail.com>
Subject: Re: [PATCH RFC v2] media: v4l2-ctrl: Add gain controls
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Chris MacGregor <chris@cybermato.com>, Rob Landley <rob@landley.net>,
        Jeongtae Park <jtp.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Wed, Dec 5, 2012 at 5:38 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> (resend without HTML formatting)
>
> On Wed 5 December 2012 12:49:29 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> add support for per color component digital/analog gain controls
>> and also their corresponding offset.
>
> Some obvious questions below...
>
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Chris MacGregor <chris@cybermato.com>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: Jeongtae Park <jtp.park@samsung.com>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> ---
>>  Changes for v2:
>>  1: Fixed review comments pointed by Laurent.
>>  2: Rebased on latest tree.
>>
>>  Documentation/DocBook/media/v4l/controls.xml |   54 ++++++++++++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c         |   11 +++++
>>  include/uapi/linux/v4l2-controls.h           |   11 +++++
>>  3 files changed, 76 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index 7fe5be1..847a9bb 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -4543,6 +4543,60 @@ interface and may change in the future.</para>
>>           specific test patterns can be used to test if a device is working
>>           properly.</entry>
>>         </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_GAIN_RED</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_GAIN_GREEN_RED</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_GAIN_GREEN_BLUE</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_GAIN_BLUE</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_GAIN_GREEN</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="descr"> Some capture/sensor devices have
>> +         the capability to set per color component digital/analog gain values.</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_GAIN_OFFSET</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_BLUE_OFFSET</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_RED_OFFSET</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_GREEN_OFFSET</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_GREEN_RED_OFFSET</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="id"><constant>V4L2_CID_GREEN_BLUE_OFFSET</constant></entry>
>> +         <entry>integer</entry>
>> +       </row>
>> +       <row>
>> +         <entry spanname="descr"> Some capture/sensor devices have the
>> +         capability to set per color component digital/analog gain offset values.
>> +         V4L2_CID_GAIN_OFFSET is the global gain offset and the rest are per
>> +         color component gain offsets.</entry>
>
> If I set both V4L2_CID_GAIN_RED and V4L2_CID_RED_OFFSET, how are they supposed
> to interact? Or are they mutually exclusive?
>
> And if I set both V4L2_CID_GAIN_OFFSET and V4L2_CID_RED_OFFSET, how are they supposed
> to interact?
>
> This questions should be answered in the documentation...
>
I haven’t worked on the hardware which supports both, What is the general
behaviour when the hardware supports both per color component and global
and both of them are set ? That could be helpful for me to document.

Regards,
--Prabhakar Lad

> Regards,
>
>         Hans
>
>> +       </row>
>>         <row><entry></entry></row>
>>       </tbody>
>>        </tgroup>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index f6ee201..05e3708 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -790,6 +790,17 @@ const char *v4l2_ctrl_get_name(u32 id)
>>       case V4L2_CID_LINK_FREQ:                return "Link Frequency";
>>       case V4L2_CID_PIXEL_RATE:               return "Pixel Rate";
>>       case V4L2_CID_TEST_PATTERN:             return "Test Pattern";
>> +     case V4L2_CID_GAIN_RED:                 return "Gain Red";
>> +     case V4L2_CID_GAIN_GREEN_RED:           return "Gain Green Red";
>> +     case V4L2_CID_GAIN_GREEN_BLUE:          return "Gain Green Blue";
>> +     case V4L2_CID_GAIN_BLUE:                return "Gain Blue";
>> +     case V4L2_CID_GAIN_GREEN:               return "Gain Green";
>> +     case V4L2_CID_GAIN_OFFSET:              return "Gain Offset";
>> +     case V4L2_CID_BLUE_OFFSET:              return "Gain Blue Offset";
>> +     case V4L2_CID_RED_OFFSET:               return "Gain Red Offset";
>> +     case V4L2_CID_GREEN_OFFSET:             return "Gain Green Offset";
>> +     case V4L2_CID_GREEN_RED_OFFSET:         return "Gain Green Red Offset";
>> +     case V4L2_CID_GREEN_BLUE_OFFSET:        return "Gain Green Blue Offset";
>>
>>       /* DV controls */
>>       case V4L2_CID_DV_CLASS:                 return "Digital Video Controls";
>> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
>> index f56c945..9b6b233 100644
>> --- a/include/uapi/linux/v4l2-controls.h
>> +++ b/include/uapi/linux/v4l2-controls.h
>> @@ -799,5 +799,16 @@ enum v4l2_jpeg_chroma_subsampling {
>>  #define V4L2_CID_LINK_FREQ                   (V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
>>  #define V4L2_CID_PIXEL_RATE                  (V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
>>  #define V4L2_CID_TEST_PATTERN                        (V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
>> +#define V4L2_CID_GAIN_RED                    (V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
>> +#define V4L2_CID_GAIN_GREEN_RED                      (V4L2_CID_IMAGE_PROC_CLASS_BASE + 5)
>> +#define V4L2_CID_GAIN_GREEN_BLUE             (V4L2_CID_IMAGE_PROC_CLASS_BASE + 6)
>> +#define V4L2_CID_GAIN_BLUE                   (V4L2_CID_IMAGE_PROC_CLASS_BASE + 7)
>> +#define V4L2_CID_GAIN_GREEN                  (V4L2_CID_IMAGE_PROC_CLASS_BASE + 8)
>> +#define V4L2_CID_GAIN_OFFSET                 (V4L2_CID_IMAGE_PROC_CLASS_BASE + 9)
>> +#define V4L2_CID_BLUE_OFFSET                 (V4L2_CID_IMAGE_PROC_CLASS_BASE + 10)
>> +#define V4L2_CID_RED_OFFSET                  (V4L2_CID_IMAGE_PROC_CLASS_BASE + 11)
>> +#define V4L2_CID_GREEN_OFFSET                        (V4L2_CID_IMAGE_PROC_CLASS_BASE + 12)
>> +#define V4L2_CID_GREEN_RED_OFFSET            (V4L2_CID_IMAGE_PROC_CLASS_BASE + 13)
>> +#define V4L2_CID_GREEN_BLUE_OFFSET           (V4L2_CID_IMAGE_PROC_CLASS_BASE + 14)
>>
>>  #endif
>>
