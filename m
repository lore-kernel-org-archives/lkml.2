Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab1ICWWK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 18:22:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:35463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1ICWWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 18:22:08 -0400
Message-ID: <4E62A872.7070808@infradead.org>
Date: Sat, 03 Sep 2011 19:21:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "Ravi, Deepthy" <deepthy.ravi@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com> <201108241329.48147.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404EC007BE3@dbde02.ent.ti.com> <201108241525.47332.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108241525.47332.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-08-2011 10:25, Laurent Pinchart escreveu:
> Hi Vaibhav,
> 
> On Wednesday 24 August 2011 14:19:01 Hiremath, Vaibhav wrote:
>> On Wednesday, August 24, 2011 5:00 PM Laurent Pinchart wrote: 
>>> On Wednesday 24 August 2011 13:21:27 Ravi, Deepthy wrote:
>>>> On Wed, Aug 24, 2011 at 4:47 PM, Laurent Pinchart wrote:
>>>>> On Friday 19 August 2011 15:48:45 Deepthy Ravi wrote:
>>>>>> From: Vaibhav Hiremath <hvaibhav@ti.com>
>>>>>>
>>>>>> Fix the build break caused when CONFIG_MEDIA_CONTROLLER
>>>>>> option is disabled and if any sensor driver has to be used
>>>>>> between MC and non MC framework compatible devices.
>>>>>>
>>>>>> For example,if tvp514x video decoder driver migrated to
>>>>>> MC framework is being built without CONFIG_MEDIA_CONTROLLER
>>>>>> option enabled, the following error messages will result.
>>>>>> drivers/built-in.o: In function `tvp514x_remove':
>>>>>> drivers/media/video/tvp514x.c:1285: undefined reference to
>>>>>> `media_entity_cleanup'
>>>>>> drivers/built-in.o: In function `tvp514x_probe':
>>>>>> drivers/media/video/tvp514x.c:1237: undefined reference to
>>>>>> `media_entity_init'
>>>>>
>>>>> If the tvp514x is migrated to the MC framework, its Kconfig option
>>>>> should depend on MEDIA_CONTROLLER.
>>>>
>>>> The same TVP514x driver is being used for both MC and non MC compatible
>>>> devices, for example OMAP3 and AM35x. So if it is made dependent on
>>>> MEDIA CONTROLLER, we cannot enable the driver for MC independent
>>>> devices.
>>>
>>> Then you should use conditional compilation in the tvp514x driver itself.
>>> Or
>>
>> No. I am not in favor of conditional compilation in driver code.
> 
> Actually, thinking some more about this, you should make the tvp514x driver 
> depend on CONFIG_MEDIA_CONTROLLER unconditionally. This doesn't mean that the 
> driver will become unusable by applications that are not MC-aware. 
> Hosts/bridges don't have to export subdev nodes, they can just call subdev 
> pad-level operations internally and let applications control the whole device 
> through a single V4L2 video node.
> 
>>> better, port the AM35x driver to the MC API.
>>
>> Why should we use MC if I have very simple device (like AM35x) which only
>> supports single path? I can very well use simple V4L2 sub-dev based
>> approach (master - slave), isn't it?
> 
> The AM35x driver should use the in-kernel MC and V4L2 subdev APIs, but it 
> doesn't have to expose them to userspace.

I don't agree. If AM35x doesn't expose the MC API to userspace, 
CONFIG_MEDIA_CONTROLLER should not be required at all.

Also, according with the Linux best practices, when  #if tests for config
symbols are required, developers should put it into the header files, and
not inside the code, as it helps to improve code readability. From
Documentation/SubmittingPatches:

	2) #ifdefs are ugly

	Code cluttered with ifdefs is difficult to read and maintain.  Don't do
	it.  Instead, put your ifdefs in a header, and conditionally define
	'static inline' functions, or macros, which are used in the code.
	Let the compiler optimize away the "no-op" case.

So, this patch is perfectly fine on my eyes.

Regards,
Mauro
