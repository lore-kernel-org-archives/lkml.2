Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1HLHZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab1HLHZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:25:33 -0400
Message-ID: <4E44D5B5.7040305@redhat.com>
Date: Fri, 12 Aug 2011 09:26:45 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
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
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <Pine.LNX.4.44L0.1108111037240.1958-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108111037240.1958-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/11/2011 04:56 PM, Alan Stern wrote:
> On Thu, 11 Aug 2011, Hans de Goede wrote:
>
>>> The alternative seems to be to define a device-sharing protocol for USB
>>> drivers.  Kernel drivers would implement a new callback (asking them to
>>> give up control of the device), and usbfs would implement new ioctls by
>>> which a program could ask for and relinquish control of a device.  The
>>> amount of rewriting needed would be relatively small.
>>>
>>> A few loose ends would remain, such as how to handle suspends, resumes,
>>> resets, and disconnects.  Assuming usbfs is the only driver that will
>>> want to share a device in this way, we could handle them.
>>>
>>> Hans, what do you think?
>>>
>>
>> First of all thanks for the constructive input!
>>
>> When you say: "device-sharing protocol", do you mean 2 drivers been
>> attached, but only 1 being active. Or just some additional glue to make
>> hand-over between them work better?
>
> I was thinking that the webcam driver would always be attached, but
> from time to time usbfs would ask to use the device.  When the webcam
> driver gives away control, it remains bound to the device but does not
> send any URBs.  If it needs to send an URB, first it has to ask usbfs
> to give control back.
>

Oh, interesting...

<snip lots of good stuff>

> I'm not claiming that this is a better solution than putting everything
> in the kernel.  Just that it is a workable alternative which would
> involve a lot less coding.

This is definitely an interesting proposal, something to think about ...

I have 2 concerns wrt this approach:

1) It feels less clean then just having a single driver; and
2) I agree it will be less coding, but I doubt it will really be that much
less work. It will likely need less new code (but a lot can be more or
less copy pasted), but it will need changes across a wider array of
subsystems / userspace components, requiring a lot of coordinating,
getting patches merged in different projects, etc. So in the end I
think it too will be quite a bit of work.

I guess that what I'm trying to say here is, that if we are going to
spend a significant amount of time on this, we might just as well
go for the best solution we can come up with even if that is some
more work.

Regards,

Hans
