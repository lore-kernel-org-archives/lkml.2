Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2ABVbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:31:06 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60766 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297Ab2ABVbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:31:03 -0500
X-Sasl-enc: T7JTuDOTUpkZpiI8oMVF0ix4hDVXaAjpcN+ujgceqIwr 1325539862
Message-ID: <4F022214.8070906@fastmail.fm>
Date: Mon, 02 Jan 2012 21:31:00 +0000
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
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com> <4F0219AB.6010505@fastmail.fm> <CA+55aFx=AEG7X2Y-LoHchgPdwNpeSkBG1J7eXprmO=czEJOD2A@mail.gmail.com> <4F021CF4.9050205@fastmail.fm> <CA+55aFx2NMDSY8rmsToU-zxe+bR-gzsxc8HajNWNWfykVJqd9w@mail.gmail.com>
In-Reply-To: <CA+55aFx2NMDSY8rmsToU-zxe+bR-gzsxc8HajNWNWfykVJqd9w@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/12 21:23, Linus Torvalds wrote:
> On Mon, Jan 2, 2012 at 1:09 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>>
>> What about USB "class" drivers e.g. usb-storage. They handle any device
>> that reports itself as a usb mass storage device. There could be a
>> device that needs to be bootstrapped before it becomes a generic usb
>> mass storage device. Do we really want to have to write a new driver
>> that is almost identical to the generic driver but handles the USB
>> firmware correctly.
> 
> I'd hope that the generic driver just expose enough interfaces that
> you could basically do a "firmware-load" driver that just loads the
> firmware and then attaches the device to the generic driver.

Sounds workable.

To make the firmware caching easier I would propose one extra function
in addition to the aforemensioned get_firmware / put_firmware - a
find_firmware function to search the cache and return the appropriate
firmware blob. It should only be called if the caller already has a
refcount to the firmware, it's only use is to save every driver saving a
pointer to the firmware.

If noone beats me to it I will try and put together an RFC for a new
version.

Thanks,

Jack

