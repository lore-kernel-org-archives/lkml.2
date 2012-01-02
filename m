Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2ABV5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 16:57:32 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35672 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358Ab2ABV5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 16:57:30 -0500
X-Sasl-enc: EEjP32ljPYV6QQykNhqb8EX2NNiY+qZxEIS2L7Jf8KTD 1325541449
Message-ID: <4F022846.8080305@fastmail.fm>
Date: Mon, 02 Jan 2012 21:57:26 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Marek Vasut <marek.vasut@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <CA+55aFx2NMDSY8rmsToU-zxe+bR-gzsxc8HajNWNWfykVJqd9w@mail.gmail.com> <4F022214.8070906@fastmail.fm> <201201022252.20139.marek.vasut@gmail.com>
In-Reply-To: <201201022252.20139.marek.vasut@gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/12 21:52, Marek Vasut wrote:
>> On 02/01/12 21:23, Linus Torvalds wrote:
>>> On Mon, Jan 2, 2012 at 1:09 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>>>> What about USB "class" drivers e.g. usb-storage. They handle any device
>>>> that reports itself as a usb mass storage device. There could be a
>>>> device that needs to be bootstrapped before it becomes a generic usb
>>>> mass storage device. Do we really want to have to write a new driver
>>>> that is almost identical to the generic driver but handles the USB
>>>> firmware correctly.
>>>
>>> I'd hope that the generic driver just expose enough interfaces that
>>> you could basically do a "firmware-load" driver that just loads the
>>> firmware and then attaches the device to the generic driver.
>>
>> Sounds workable.
>>
>> To make the firmware caching easier I would propose one extra function
>> in addition to the aforemensioned get_firmware / put_firmware - a
>> find_firmware function to search the cache and return the appropriate
>> firmware blob. It should only be called if the caller already has a
>> refcount to the firmware, it's only use is to save every driver saving a
>> pointer to the firmware.
>>
>> If noone beats me to it I will try and put together an RFC for a new
>> version.
> 
> The problem is on systems with limited resources, most notably RAM. If you plug 
> in many devices at once, many firmwares will be cached at one point, efectivelly 
> doing DoS attach on the machine?
> 
> Also, how will this solve the suspect-resume issue? What if the device suspends 
> only occasionally -- like every 24 hours -- then you'd have the FW cached all 
> the time too?

Yes, at least to begin with. If we can come up with a robust scheme
which doesn't require the firmware to be kept in memory then that would
also be workable.

For example, drivers which know they don't ever need the firmware again
wouldn't need to cache it. That would probably be quite a small list -
there are systems that cut power to USB devices over suspend and so
those devices would need the firmware reloading.

I don't think there is anyway to avoid the memory requirement if we want
to be able to resume transparently to user-space (or even resume at all
in some setups).

Thanks,

Jack

