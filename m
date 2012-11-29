Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2K2Mqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:46:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54827 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab2K2Mqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:46:50 -0500
Message-ID: <50B758F3.5060008@ti.com>
Date: Thu, 29 Nov 2012 18:15:39 +0530
From: Manjunath Hadli <manjunath.hadli@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Hans Verkuil <hansverk@cisco.com>, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 0/9] Media Controller capture driver for DM365
References: <1354099329-20722-1-git-send-email-prabhakar.lad@ti.com> <201211282018.20832.hverkuil@xs4all.nl> <20121128193021.GA4174@kroah.com> <201211290843.36468.hverkuil@xs4all.nl> <20121129083956.227f55ee@redhat.com>
In-Reply-To: <20121129083956.227f55ee@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Thursday 29 November 2012 04:09 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 29 Nov 2012 08:43:36 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On Wed November 28 2012 20:30:21 Greg Kroah-Hartman wrote:
>>> On Wed, Nov 28, 2012 at 08:18:20PM +0100, Hans Verkuil wrote:
>>>> On Wed November 28 2012 18:22:48 Greg Kroah-Hartman wrote:
>>>>> On Wed, Nov 28, 2012 at 10:18:02AM -0200, Mauro Carvalho Chehab wrote:
>>>>>> Em Wed, 28 Nov 2012 12:56:10 +0100
>>>>>> Hans Verkuil <hansverk@cisco.com> escreveu:
>>>>>>
>>>>>>> On Wed 28 November 2012 12:45:37 Dan Carpenter wrote:
>>>>>>>> I wish people wouldn't submit big patches right before the merge
>>>>>>>> window opens...  :/ It's better to let it sit in linux-next for a
>>>>>>>> couple weeks so people can mess with it a bit.
>>>>>>>
>>>>>>> It's been under review for quite some time now, and the main change since
>>>>>>> the last posted version is that this is now moved to staging/media.
>>>>>>>
>>>>>>> So it is not yet ready for prime time, but we do want it in to simplify
>>>>>>> the last remaining improvements needed to move it to drivers/media.
>>>>>>
>>>>>> "last remaining improvements"? I didn't review the patchset, but
>>>>>> the TODO list seems to have several pending stuff there:
>>>>>>
>>>>>> +- User space interface refinement
>>>>>> +        - Controls should be used when possible rather than private ioctl
>>>>>> +        - No enums should be used
>>>>>> +        - Use of MC and V4L2 subdev APIs when applicable
>>>>>> +        - Single interface header might suffice
>>>>>> +        - Current interface forces to configure everything at once
>>>>>> +- Get rid of the dm365_ipipe_hw.[ch] layer
>>>>>> +- Active external sub-devices defined by link configuration; no strcmp
>>>>>> +  needed
>>>>>> +- More generic platform data (i2c adapters)
>>>>>> +- The driver should have no knowledge of possible external subdevs; see
>>>>>> +  struct vpfe_subdev_id
>>>>>> +- Some of the hardware control should be refactorede
>>>>>> +- Check proper serialisation (through mutexes and spinlocks)
>>>>>> +- Names that are visible in kernel global namespace should have a common
>>>>>> +  prefix (or a few)
>>>>>>
>>>>>> From the above comments, both Kernelspace and Userspace APIs require 
>>>>>> lots of work.
>>>>
>>>> And that's why it is in staging. Should a long TODO list now suddenly
>>>> prevent staging from being used? In Barcelona we discussed this and the
>>>> only requirement we came up was was that it should compile.
>>>
>>> Yes, that's all I care about in staging, but as I stated, I don't
>>> maintain drivers/staging/media/ that area is under Mauro's control
>>> (MAINTAINERS even says this), and I'm a bit leery of going against the
>>> wishes of an existing subsystem maintainer for adding staging drivers
>>> that tie into their subsystem.
> 
> On my understanding, this is not a "normal" staging driver for some
> unsupported hardware. It is a driver that is meant to replace an 
> existing driver, whose plans is to implement a different, userspace-incompatible
> API set than the existing one. In other words, merging it as-is would give the
> false impression that only solving the TODO items would be enough to promote it.
> 
> However, the main criteria for a replacement driver is to not cause any
> regression. So, a compatibility layer and compatibility tests that warrants
> this is a requirement (eventually using the  libv4l's LD_PRELOAD approach). 
> 
> So, if the ones working on the driver are also willing to work on the 
> needed compatibility bits, I'm ok on merging it at staging; if not, there's
> no sense on spending everybody's time on something that will be discarded
> on a few kernel cycles.
> 
> So, the main discussion here is not about merging it at staging or not; is
> to be sure that, once it got merged, the right things will be addressed,
> in order to allow it to replace the existing driver.
> 
> Of course, Dan's request is valid; pushing it right now at -next will give
> only a week for the others to review a big driver. So, better to delay it.
> 
> In any case, there are already 400+ patches on my queue that arrived
> before these late-submitted patch series. So, it would be delayed
> anyway to the next cycle, due to the very high volume of pending stuff
> there, and to his late submission.
> 
> So, in summary:
> 
> Prabhakar/Manju:
> 
> If you'll be committed to make sure that no regressions will happen when this
> driver will be promoted and replace the existing driver, please update
> the TODO to point that the compatibility bits is needed.
Sure Mauro. All this long wait to get into the mainline would be for
nothing if we do not go ahead and make the necessary changes you want us
to do to get to the media folder. We will update the TODO patch and
resend the series.
> 
> I'll then merge it after the end of the merge window.
thank you very much.
> 
> Regards,
> Mauro
> 
Thanks and Regards,
-Manju

