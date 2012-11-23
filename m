Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2KWNVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 08:21:51 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61884 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2KWNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 08:21:50 -0500
MIME-Version: 1.0
In-Reply-To: <20121123131344.GA31879@valkosipuli.retiisi.org.uk>
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com> <20121123131344.GA31879@valkosipuli.retiisi.org.uk>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 23 Nov 2012 18:51:28 +0530
Message-ID: <CA+V-a8t5ZJ2Zb+dWkifjjOHOrv1LAvgaJR2x24xKJXrTJs9+jg@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] Media Controller capture driver for DM365
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On Fri, Nov 23, 2012 at 6:43 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Prabhakar and others,
>
> (Just resending; Laurent's e-mail address corrected, cc Hans, too.)
>
> On Fri, Nov 16, 2012 at 08:15:02PM +0530, Prabhakar Lad wrote:
>> From: Manjunath Hadli <manjunath.hadli@ti.com>
>>
>> This patch set adds media controller based capture driver for
>> DM365.
>>
>> This driver bases its design on Laurent Pinchart's Media Controller Design
>> whose patches for Media Controller and subdev enhancements form the base.
>> The driver also takes copious elements taken from Laurent Pinchart and
>> others' OMAP ISP driver based on Media Controller. So thank you all the
>> people who are responsible for the Media Controller and the OMAP ISP driver.
>>
>> Also, the core functionality of the driver comes from the arago vpfe capture
>> driver of which the isif capture was based on V4L2, with other drivers like
>> ipipe, ipipeif and Resizer.
>>
>> Changes for v2:
>> 1: Migrated the driver for videobuf2 usage pointed Hans.
>> 2: Changed the design as pointed by Laurent, Exposed one more subdevs
>>    ipipeif and split the resizer subdev into three subdevs.
>> 3: Rearrganed the patch sequence and changed the commit messages.
>> 4: Changed the file architecture as pointed by Laurent.
>>
>> Manjunath Hadli (12):
>>   davinci: vpfe: add v4l2 capture driver with media interface
>>   davinci: vpfe: add v4l2 video driver support
>>   davinci: vpfe: dm365: add IPIPEIF driver based on media framework
>>   davinci: vpfe: dm365: add ISIF driver based on media framework
>>   davinci: vpfe: dm365: add IPIPE support for media controller driver
>>   davinci: vpfe: dm365: add IPIPE hardware layer support
>>   davinci: vpfe: dm365: resizer driver based on media framework
>>   davinci: vpss: dm365: enable ISP registers
>>   davinci: vpss: dm365: set vpss clk ctrl
>>   davinci: vpss: dm365: add vpss helper functions to be used in the
>>     main driver for setting hardware parameters
>>   davinci: vpfe: dm365: add build infrastructure for capture driver
>>   davinci: vpfe: Add documentation
>
> As discussed, here's the todo list for inclusion to staging.
>
> - User space interface refinement
>         - Controls should be used when possible rather than private ioctl
>         - No enums should be used
>         - Use of MC and V4L2 subdev APIs when applicable
>         - Single interface header might suffice
>         - Current interface forces to configure everything at once
> - Get rid of the dm365_ipipe_hw.[ch] layer
> - Active external sub-devices defined by link configuration; no strcmp
>   needed
> - More generic platform data (i2c adapters)
> - The driver should have no knowledge of possible external subdevs; see
>   struct vpfe_subdev_id
> - Some of the hardware control should be refactorede
> - Check proper serialisation (through mutexes and spinlocks)
> - Names that are visible in kernel global namespace should have a common
>   prefix (or a few)
>
> This list likely isn't complete, but some items such as the locking one is
> there simply because I'm not certain of the state of it.
>
Thanks a lot. I'll include this TODO's in documentation patch itself,
But I am not sure if the driver is going in staging, the documentation
file would still be present under Documentation directory  or even
this should go in staging directory itself ?

Regards,
--Prabhakar Lad

> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
