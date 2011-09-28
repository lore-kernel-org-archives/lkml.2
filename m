Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1I1J2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:28:43 -0400
Received: from smtp.nokia.com ([147.243.128.24]:33001 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1I1J2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:28:42 -0400
Message-ID: <4E82E8AF.8080609@iki.fi>
Date: Wed, 28 Sep 2011 12:28:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110902 Firefox/6.0.2 SeaMonkey/2.3.3
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Ravi, Deepthy" <deepthy.ravi@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
References: <1315488922-16152-1-git-send-email-deepthy.ravi@ti.com> <201109161506.16505.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404EC8113E2@dbde02.ent.ti.com> <201109272006.30130.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404ECA54C58@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404ECA54C58@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiremath,

Hiremath, Vaibhav wrote:
>> -----Original Message----- From: Laurent Pinchart
>> [mailto:laurent.pinchart@ideasonboard.com] Sent: Tuesday, September
>> 27, 2011 11:36 PM To: Hiremath, Vaibhav Cc: Ravi, Deepthy;
>> linux-media@vger.kernel.org; tony@atomide.com; 
>> linux@arm.linux.org.uk; linux-omap@vger.kernel.org; linux-arm- 
>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; 
>> mchehab@infradead.org; g.liakhovetski@gmx.de Subject: Re: [PATCH
>> 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
>> 
>> Hi Vaibhav,
>> 
>> On Monday 19 September 2011 17:31:02 Hiremath, Vaibhav wrote:
>>> On Friday, September 16, 2011 6:36 PM Laurent Pinchart wrote:
>>>> On Friday 16 September 2011 15:00:53 Ravi, Deepthy wrote:
>>>>> On Thursday, September 08, 2011 10:51 PM Laurent Pinchart
>>>>> wrote:
>>>>>> On Thursday 08 September 2011 15:35:22 Deepthy Ravi wrote:
>>>>>>> From: Vaibhav Hiremath <hvaibhav@ti.com>
>>>>>>> 
>>>>>>> In order to support TVP5146 (for that matter any video
>>>>>>> decoder), it is important to support G/S/ENUM_STD ioctl
>>>>>>> on /dev/videoX device node.
>>>>>> 
>>>>>> Why so ? Shouldn't it be queried on the subdev output pad
>> directly ?
>>>>> 
>>>>> Because standard v4l2 application for analog devices will
>>>>> call these std ioctls on the streaming device node. So it's
>>>>> done on /dev/video
>> to
>>>>> make the existing apllication work.
>>>> 
>>>> Existing applications can't work with the OMAP3 ISP (and
>>>> similar
>> complex
>>>> embedded devices) without userspace support anyway, either in
>>>> the form
>> of
>>>> a GStreamer element or a libv4l plugin. I still believe that
>>>> analog
>> video
>>>> standard operations should be added to the subdev pad
>>>> operations and exposed through subdev device nodes, exactly as
>>>> done with formats.
>>> 
>>> I completely agree with your point that, existing application
>>> will not
>> work
>>> without setting links properly. But I believe the assumption here
>>> is, media-controller should set the links (along with pad
>>> formants) and all existing application should work as is. Isn't
>>> it?
>> 
>> The media controller is an API used (among other things) to set the
>> links. You still need to call it from userspace. That won't happen
>> magically. The userspace component that sets up the links and
>> configures the formats, be it a GStreamer element, a libv4l plugin,
>> or something else, can as well setup the standard on the TVP5146
>> subdev.
>> 
> Please look at from analog device point of view which is interfaced
> to ISP.
> 
> OMAP3 ISP => TVP5146 (video decoder)
> 
> As a user I would want to expect the standard to be supported on
> streaming device node, since all standard streaming applications (for
> analog devices/interfaces) does this.
> 
> Setting up the links and format is still something got added with MC
> framework, and I would consider it as a separate plug-in along with
> existing applications.
> 
> Why do I need to write/use two different streaming application one
> for MC compatible device and another for non-MC?

You musn't need to.

This is something that will have to be handled by the libv4l plugin, as
the rest of controlling the device. Controls related ioctls will be
passed from the source to downstream once they apply, and I don't see
why the same shouldn't be done to the {G,S,ENUM}_STD.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
