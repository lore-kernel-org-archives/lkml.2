Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1HKLUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:20:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:42560 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1HKLUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:20:17 -0400
Message-ID: <4E43BAB5.60406@infradead.org>
Date: Thu, 11 Aug 2011 08:19:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <Pine.LNX.4.44L0.1108101156350.1917-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1108101300500.25084@banach.math.auburn.edu> <4E42E68D.6040501@infradead.org> <20110811105750.179e468a@tele>
In-Reply-To: <20110811105750.179e468a@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-08-2011 05:57, Jean-Francois Moine escreveu:
> On Wed, 10 Aug 2011 17:14:05 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
>>> -- moving the kernel webcam drivers out of the kernel and doing with these 
>>> cameras _everything_ including webcam function through libusb. I myself do 
>>> not have the imagination to be able to figure out how this could be done 
>>> without a rather humongous amount of work (for example, which streaming 
>>> apps that are currently available would be able to live with this?) but 
>>> unless I misunderstand what he was saying, Greg K-H seems to think that 
>>> this would be the best thing to do.  
>>
>> I also don't think that this a good alternative. As Hans V. pointed, one of
>> our long term targets is to create per-sensor I2C drivers that are independent
>> from the bridges. Also, moving it to userspace would require lots of work
>> with the duplication of V4L and gspca core into userspace for the devices
>> that would be moved, and may have some performance impacts.
> 
> If only gspca subdrivers are concerned, moving them to usespace should
> be easy: only the gspca main has to be rewritten, and its best place is
> in the v4l library.

It would end by having two userspace drivers, as the data access driver is 
at libgphoto2. So, the problem will just be moved to userspace. You'll
additionally need to deal with conflicts between kernelspace ALSA driver
and userspace video driver.

Regards,
Mauro.




