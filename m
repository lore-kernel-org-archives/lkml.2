Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2H3RzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:55:04 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36547 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753617Ab2H3Ry4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:54:56 -0400
Message-ID: <503FA8EC.8030309@iki.fi>
Date: Thu, 30 Aug 2012 20:54:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120715 Firefox/14.0.1 SeaMonkey/2.11
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Prabhakar Lad <prabhakar.lad@ti.com>, LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] media: v4l2-ctrls: add control for dpcm predictor
References: <1346313496-3652-1-git-send-email-prabhakar.lad@ti.com> <201208300757.44775.hverkuil@xs4all.nl>
In-Reply-To: <201208300757.44775.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans and Prabhakar,

Hans Verkuil wrote:
> Hi Prabhakar!
>
> I've got some documentation review comments below...
>
> On Thu August 30 2012 00:58:16 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> add V4L2_CID_DPCM_PREDICTOR control of type menu, which
>> determines the dpcm predictor. The predictor can be either
>> simple or advanced.
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
>> ---
>> This patches has one checkpatch warning for line over
>> 80 characters altough it can be avoided I have kept it
>> for consistency.
>>
>> Changes for v2:
>> 1: Added documentaion in controls.xml pointed by Sylwester.
>> 2: Chnaged V4L2_DPCM_PREDICTOR_ADVANCE to V4L2_DPCM_PREDICTOR_ADVANCED
>>     pointed by Sakari.
>>
>>   Documentation/DocBook/media/v4l/controls.xml |   25 ++++++++++++++++++++++++-
>>   drivers/media/v4l2-core/v4l2-ctrls.c         |    9 +++++++++
>>   include/linux/videodev2.h                    |    5 +++++
>>   3 files changed, 38 insertions(+), 1 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index 93b9c68..84746d0 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -4267,7 +4267,30 @@ interface and may change in the future.</para>
>>   	    pixels / second.
>>   	    </entry>
>>   	  </row>
>> -	  <row><entry></entry></row>
>> +	  <row>
>> +	    <entry spanname="id"><constant>V4L2_CID_DPCM_PREDICTOR</constant></entry>
>> +	    <entry>menu</entry>
>> +	  </row>
>> +	  <row id="v4l2-dpcm-predictor">
>> +	    <entry spanname="descr"> DPCM Predictor: depicts what type of prediction
>> +	    is used simple or advanced.
>
> This is not useful information. It basically just rephrases the name of the
> define without actually telling me anything.
>
> I would expect to see here at least the following:
>
> - what the DPCM abbreviation stands for
> - a link or bibliography reference to the relevant standard (if there is any)

There's a Wikipedia article:

<URL:http://en.wikipedia.org/wiki/Differential_pulse-code_modulation>

It's the same DPCM encoding as in many of the compressed raw bayer formats.

> - a high-level explanation of what this do and what the difference is between
>   simple and advanced.

That's somewhat subjective and hardware dependent. If I understand this 
correctly, the "advanced" should differ only quality-wise from "simple" 
option. Why one would use "simple" instead of "advanced" then? Perhaps 
mostly for testing purposes; it might be that the advanced predictor 
could have issues in certain cases where the simple would not. However 
this isn't the only piece of hardware where I see that this is 
configurable, and the simple one was even the default.

> If this is part of a video compression standard, then this control would probably
> belong to the MPEG control class as well.

It's not --- DPCM compression is typically used on the bus between the 
sensor and the receiver to compress the data as the bus is often a 
limiting factor in the transfer rate. DPCM compression can be used to 
squeeze the data from 10 to 8 bits without much loss in quality or 
dynamic range.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi

