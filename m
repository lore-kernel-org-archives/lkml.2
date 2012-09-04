Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2IDFGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 01:06:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49142 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2IDFGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 01:06:15 -0400
Message-ID: <50458C21.2090000@ti.com>
Date: Tue, 4 Sep 2012 10:35:37 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-doc@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>, HeungJun Kim <riverful.kim@samsung.com>
Subject: Re: [PATCH] media: v4l2-ctrls: add control for test pattern
References: <1346663777-23149-1-git-send-email-prabhakar.lad@ti.com> <20120903193947.GD6834@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120903193947.GD6834@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the review.

On Tuesday 04 September 2012 01:09 AM, Sakari Ailus wrote:
> Hi Prabhakar,
> 
> Thanks for the patch.
> 
> On Mon, Sep 03, 2012 at 02:46:17PM +0530, Prabhakar Lad wrote:
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
>> +	        <row>
>> +	          <entry><constant>V4L2_TEST_PATTERN_CHECKER_BOARD</constant></entry>
>> +	          <entry>Generate a checker board as test pattern</entry>
>> +	        </row>
> 
> You're defining 8 different test patterns based on a single device, I guess? 
> 
No.

> As the test patterns are not standardised, I'd suppose that if another
> driver implements the same control, it would require another n menu items
> added to the same standard menu. That way we'd run quickly out of menu items
> as the maximum is 32.
> 
Agreed the test patterns are not standardized and are hardware
dependent, but this entries which have been added are generally common
across capture/display/sensors.

> For this reason I'd leave the items in the menu up to the driver that
> implements the control, until we have more information on the test patterns
> different devices implement --- as discussed earlier.
> 
Assuming that I only added disable test pattern and if a driver wants to
implement this control and wants add  an item to this menu, on what
basis an entry to this menu will be qualified then ?

Thanks and Regards,
--Prabhakar Lad

> Kind regards,
> 

