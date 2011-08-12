Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1HLHPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:15:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1HLHPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:15:07 -0400
Message-ID: <4E44D330.2040702@redhat.com>
Date: Fri, 12 Aug 2011 09:16:00 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
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
References: <Pine.LNX.4.44L0.1108111145360.1958-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1108111235400.27040@banach.math.auburn.edu> <4E443C6E.8040808@infradead.org>
In-Reply-To: <4E443C6E.8040808@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/11/2011 10:32 PM, Mauro Carvalho Chehab wrote:

<snip stuff I agree with>

> instead of using the V4L2 device node to access the stored images, it probably makes
> more sense to use a separate device for that, that will handle a separate set of
> ioctl's, and just use read() to retrieve the image data, after selecting the desired
> image number, via ioctl().

I don't see a lot of added value in doing things this way. We can simply
have a set of new ioctls on the /dev/video# node for this and a new
V4L2_CAP_STILL_IMAGE to indicate the availability of these ioctls. This will keep
the driver a lot simpler then doing 2 separate device nodes for 1 device.

Regards,

Hans
