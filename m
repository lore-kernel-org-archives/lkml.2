Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2ICJrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:47:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37682 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2ICJrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:47:14 -0400
Message-ID: <50447C88.3030401@ti.com>
Date: Mon, 3 Sep 2012 15:16:48 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-doc@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>, HeungJun Kim <riverful.kim@samsung.com>
Subject: Re: [PATCH] media: v4l2-ctrls: add control for test pattern
References: <1346663777-23149-1-git-send-email-prabhakar.lad@ti.com> <201209031122.17568.hverkuil@xs4all.nl>
In-Reply-To: <201209031122.17568.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

Thanks for the review.

On Monday 03 September 2012 02:52 PM, Hans Verkuil wrote:
> On Mon September 3 2012 11:16:17 Prabhakar Lad wrote:
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
>> Cc: HeungJun Kim <riverful.kim@samsung.com>
>> Cc: Rob Landley <rob@landley.net>
>> ---
>>  This patches has one checkpatch warning for line over
>>  80 characters altough it can be avoided I have kept it
>>  for consistency.
>>
>>  Documentation/DocBook/media/v4l/controls.xml |   52 ++++++++++++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c         |   16 ++++++++
>>  include/linux/videodev2.h                    |   12 ++++++
>>  3 files changed, 80 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index f704218..06f16e7 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -4313,6 +4313,58 @@ interface and may change in the future.</para>
>>  	      </tbody>
>>  	    </entrytbl>
>>  	  </row>
>> +	  <row>
>> +	    <entry spanname="id"><constant>V4L2_CID_TEST_PATTERN</constant></entry>
>> +	    <entry>menu</entry>
>> +	  </row>
>> +	  <row id="v4l2-test-pattern">
>> +	    <entry spanname="descr"> The capture devices/sensors have the capability to
> 
> Test patterns are also applicable to output devices, not just capture and sensor devices.
> 
Agreed. I'll make it 'capture/display/sensors'.

>> +	    generate internal test patterns. This test patterns are used to test a device
>> +	    is properly working and can generate the desired waveforms that it supports.
>> +	    </entry>
>> +	  </row>
>> +	  <row>
>> +	    <entrytbl spanname="descr" cols="2">
>> +	      <tbody valign="top">
>> +	        <row>
>> +	         <entry><constant>V4L2_TEST_PATTERN_DISABLED</constant></entry>
>> +	          <entry>Test pattern generation is disabled</entry>
>> +	        </row>
>> +	        <row>
>> +	          <entry><constant>V4L2_TEST_PATTERN_VERTICAL_LINES</constant></entry>
>> +	          <entry>Generate vertical lines as test pattern</entry>
>> +	        </row>
>> +	        <row>
>> +	          <entry><constant>V4L2_TEST_PATTERN_HORIZONTAL_LINES</constant></entry>
>> +	          <entry>Generate horizontal lines as test pattern</entry>
>> +	        </row>
>> +	        <row>
>> +	          <entry><constant>V4L2_TEST_PATTERN_DIAGONAL_LINES</constant></entry>
>> +	          <entry>Generate diagonal lines as test pattern</entry>
>> +	        </row>
>> +	        <row>
>> +	          <entry><constant>V4L2_TEST_PATTERN_SOLID_BLACK</constant></entry>
>> +	          <entry>Generate solid black color as test pattern</entry>
>> +	        </row>
>> +	        <row>
>> +	          <entry><constant>V4L2_TEST_PATTERN_SOLID_WHITE</constant></entry>
>> +	          <entry>Generate solid white color as test pattern</entry>
>> +	        </row>
>> +	        <row>
>> +	          <entry><constant>V4L2_TEST_PATTERN_SOLID_BLUE</constant></entry>
>> +	          <entry>Generate solid blue color as test pattern</entry>
>> +	        </row>
>> +	        <row>
>> +	          <entry><constant>V4L2_TEST_PATTERN_SOLID_RED</constant></entry>
>> +	          <entry>Generate solid red color as test pattern</entry>
>> +	        </row>
> 
> Just wondering: is there no SOLID_GREEN available with this sensor?
> 
Not sure I guess it should be.

Thanks and Regards,
--Prabhakar Lad

> Regards,
> 
> 	Hans
> 
>> +	        <row>
>> +	          <entry><constant>V4L2_TEST_PATTERN_CHECKER_BOARD</constant></entry>
>> +	          <entry>Generate a checker board as test pattern</entry>
>> +	        </row>
>> +	      </tbody>
>> +	    </entrytbl>
>> +	  </row>
>>  	<row><entry></entry></row>
>>  	</tbody>
>>        </tgroup>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 2d7bc15..ae709d1 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -430,6 +430,18 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>  		"Advanced Predictor",
>>  		NULL,
>>  	};
>> +	static const char * const test_pattern[] = {
>> +		"Test Pattern Disabled",
>> +		"Vertical Lines",
>> +		"Horizontal Lines",
>> +		"Diagonal Lines",
>> +		"Solid Black",
>> +		"Solid White",
>> +		"Solid Blue",
>> +		"Solid Red",
>> +		"Checker Board",
>> +		NULL,
>> +	};
>>  
>>  	switch (id) {
>>  	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
>> @@ -509,6 +521,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>  		return jpeg_chroma_subsampling;
>>  	case V4L2_CID_DPCM_PREDICTOR:
>>  		return dpcm_predictor;
>> +	case V4L2_CID_TEST_PATTERN:
>> +		return test_pattern;
>>  
>>  	default:
>>  		return NULL;
>> @@ -740,6 +754,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>>  	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
>>  	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
>>  	case V4L2_CID_DPCM_PREDICTOR:		return "DPCM Predictor";
>> +	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
>>  
>>  	default:
>>  		return NULL;
>> @@ -841,6 +856,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>>  	case V4L2_CID_EXPOSURE_METERING:
>>  	case V4L2_CID_SCENE_MODE:
>>  	case V4L2_CID_DPCM_PREDICTOR:
>> +	case V4L2_CID_TEST_PATTERN:
>>  		*type = V4L2_CTRL_TYPE_MENU;
>>  		break;
>>  	case V4L2_CID_LINK_FREQ:
>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>> index ca9fb78..1796079 100644
>> --- a/include/linux/videodev2.h
>> +++ b/include/linux/videodev2.h
>> @@ -2005,6 +2005,18 @@ enum v4l2_dpcm_predictor {
>>  	V4L2_DPCM_PREDICTOR_SIMPLE	= 0,
>>  	V4L2_DPCM_PREDICTOR_ADVANCED	= 1,
>>  };
>> +#define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
>> +enum v4l2_test_pattern {
>> +	V4L2_TEST_PATTERN_DISABLED		= 0,
>> +	V4L2_TEST_PATTERN_VERTICAL_LINES	= 1,
>> +	V4L2_TEST_PATTERN_HORIZONTAL_LINES	= 2,
>> +	V4L2_TEST_PATTERN_DIAGONAL_LINES	= 3,
>> +	V4L2_TEST_PATTERN_SOLID_BLACK		= 4,
>> +	V4L2_TEST_PATTERN_SOLID_WHITE		= 5,
>> +	V4L2_TEST_PATTERN_SOLID_BLUE		= 6,
>> +	V4L2_TEST_PATTERN_SOLID_RED		= 7,
>> +	V4L2_TEST_PATTERN_CHECKER_BOARD		= 8,
>> +};
>>  
>>  /*
>>   *	T U N I N G
>>

