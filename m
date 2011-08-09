Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1HIT4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:56:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab1HIT4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:56:22 -0400
Message-ID: <4E41912F.50901@redhat.com>
Date: Tue, 09 Aug 2011 21:57:35 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/09/2011 04:19 PM, Alan Stern wrote:
> On Tue, 9 Aug 2011, Hans de Goede wrote:
>
>> I would really like to see the dual mode camera and TV tuner discussion
>> separated. They are 2 different issues AFAIK.
>>
>> 1) Dual mode cameras:
>>
>> In the case of the dual mode camera we have 1 single device (both at
>> the hardware level and at the logical block level), which can do 2 things,
>> but not at the same time. It can stream live video data from a sensor,
>> or it can retrieve earlier taken pictures from some picture memory.
>>
>> Unfortunately even though these 2 functions live in a single logical block,
>> historically we've developed 2 drivers for them. This leads to fighting
>> over device ownership (surprise surprise), and to me the solution is
>> very clear, 1 logical block == 1 driver.
>
> According to Theodore, we have developed 5 drivers for them because the
> stillcam modes in different devices use four different vendor-specific
> drivers.

Yes, but so the the webcam modes of the different devices, so for
the 5 (not sure if that is the right number) dual-cam mode chipsets
we support there will be 5 drivers, each supporting both the
webcam and the access to pictures stored in memory of the chipset
they support. So 5 chipsets -> 5 drivers each supporting 1 chipset,
and both functions of the single logical device that chipset
represents.

>  Does it really make sense to combine 5 drivers into one?

Right, that is not the plan. The plan is to simply stop having 2 drivers
for 1 logical (and physical) block. So we go from 10 drivers, 5 stillcam
+ 5 webcam, to just 5 drivers. We will also likely be able to share
code between the code for the 2 functionalities for things like generic
set / get register functions, initialization, etc.

Regards,

Hans
