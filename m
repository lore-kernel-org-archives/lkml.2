Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2ABVJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:09:13 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43673 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335Ab2ABVJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:09:11 -0500
X-Sasl-enc: vC9auJAueeaGt08CaQ7l8wHeukm5poGLu56PuN2EI7Dw 1325538550
Message-ID: <4F021CF4.9050205@fastmail.fm>
Date: Mon, 02 Jan 2012 21:09:08 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
        Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com> <4F0219AB.6010505@fastmail.fm> <CA+55aFx=AEG7X2Y-LoHchgPdwNpeSkBG1J7eXprmO=czEJOD2A@mail.gmail.com>
In-Reply-To: <CA+55aFx=AEG7X2Y-LoHchgPdwNpeSkBG1J7eXprmO=czEJOD2A@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/12 21:00, Linus Torvalds wrote:
> On Mon, Jan 2, 2012 at 12:55 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>>
>> The problem comes with knowing when to put the firmware - how do we tell
>> the generic driver that that device has firmware that might need to be
>> freed on disconnect. I don't know enough about USB to know if we can
>> tell if the same device has reconnected due to firmware being loaded or
>> if it was simply unplugged and a new device plugged in.
> 
> Well, if we just have a 10-second timeout for the firmware flushing
> after the last "put" operation, we don't even care.
> 
> It doesn't even *matter* if the device is a physically different
> device - if the driver loads the same firmware, it will be cached, and
> it will still be correct for that (physically different, but with the
> same firmware requirements) device. So even the whole "user switched
> devices around" issue is irrelevant.
> 
> Of course, if the driver is some piece-of-crap that explicitly loads
> the wrong firmware for the device it manages, the firmware will be
> wrong, but hey, "Don't do that then". The drivers job very much
> includes being able to look at the device ID (whether USB or PCIe or
> PCMCIA) and figure out which firmware image it needs to load.

What about USB "class" drivers e.g. usb-storage. They handle any device
that reports itself as a usb mass storage device. There could be a
device that needs to be bootstrapped before it becomes a generic usb
mass storage device. Do we really want to have to write a new driver
that is almost identical to the generic driver but handles the USB
firmware correctly.

The other option is to extend the class drivers to understand that a
certain device needs this piece of firmware and to handle it but that
will bloat the generic drivers with lots of vendor stuff. We could do
this by lists of USB ids or something similar.

Thanks,

Jack

