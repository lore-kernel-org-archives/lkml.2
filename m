Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0DSPAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:00:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab0DSPAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:00:07 -0400
Message-ID: <4BCC6FAF.2030809@redhat.com>
Date: Mon, 19 Apr 2010 16:58:55 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: mdharm-kernel@one-eyed-alien.net
CC: digidietze@draisberghof.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: expose Huawei E1550 3G modem
References: <4BCC5071.4010509@redhat.com> <4BCC6206.4030003@draisberghof.de> <4BCC63EB.4010204@redhat.com> <20100419141907.GN26130@one-eyed-alien.net>
In-Reply-To: <20100419141907.GN26130@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.2010 16:19, Matthew Dharm wrote:
> On Mon, Apr 19, 2010 at 04:08:43PM +0200, Stefan Assmann wrote:
>> On 19.04.2010 16:00, Josua Dietze wrote:
>>> Stefan Assmann schrieb:
>>>> The Huawei E1550 3G modem is hidden by default and can be
>>>> exposed by sending some magic initialization code. This
>>>> patch takes care of that.
>>>
>>> This device (as all other Huaweis using this sequence) is 
>>> supported by the usb_modeswitch tool which takes of the 
>>> switching process. Once installed, no user interaction is 
>>> required except plugging.
>>>
>>> Current policy is to leave switching to the userspace if it's 
>>> working there.
>>
>> that's good news. This is part of hardware initialization, so let's move
>> it to the kernel. Or do you know any good reason why the kernel
>> shouldn't handle it?
> 
> We've had this discussion, what, over a dozen times already?  It keeps
> coming up every few months.
> 
> There are two primary reasons to keep this in userspace:
> 
> 1) Someone might actually want to access the storage mode of these devices.
> It has come up in the past, and there is no good reason the kernel should
> deny access to that function of the device by enforcing a switchover.

You're right about that. For the E1550 it doesn't hide any devices. I'm
still able to access the virtual CDROM and the microSD card. Josua, you
might know more about that, isn't the hidding of the CDROM/microSD part
done separately?

> 
> 2) It is much much easier to update a userspace tool than the kernel.
> Thus, new devices can be supported without a kernel update by end-users.

Of course. Nobody is talking about removing existing code from any
user-space application. Under the condition that no functionality gets
lost, wouldn't it be convenient to have the modem exposed by the kernel?
If the kernel support doesn't suffice you can still run an updated
usb_modeswitch until kernel support is there.

This also has the benefit that it would work for people that don't
have usb_modeswitch installed. Matt, are you still thinking that is the
wrong way of doing it?

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
