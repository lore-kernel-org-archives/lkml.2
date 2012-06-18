Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2FRJet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:34:49 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:38752 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752238Ab2FRJeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:34:46 -0400
MIME-Version: 1.0
In-Reply-To: <87fwa01mso.fsf@ti.com>
References: <1338375394-16268-1-git-send-email-kishon@ti.com>
	<201205310922.18550.arnd@arndb.de>
	<CAAe_U6J3p9Lh9g82tSSLxOJ7nqrozdRe11zV_v2rqTuMYPjbyA@mail.gmail.com>
	<201205312046.14823.arnd@arndb.de>
	<CAAe_U6+zi50muNFKXW9ytK0BVki+5wxVK_S0rjEc53M2oc-GeQ@mail.gmail.com>
	<87fwa01mso.fsf@ti.com>
Date: Mon, 18 Jun 2012 15:04:44 +0530
Message-ID: <CAAe_U6LT5f+bydfUK1i6F7bsJZXo1534o=BC4whxejEjsrZpsA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] omap: add ocp2scp as a misc driver
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Cousson, Benoit" <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, tony@atomide.com,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Tue, Jun 12, 2012 at 10:37 PM, Kevin Hilman <khilman@ti.com> wrote:
> "ABRAHAM, KISHON VIJAY" <kishon@ti.com> writes:
>
>> Hi Kevin, Benoit, Paul,
>>
>> On Fri, Jun 1, 2012 at 2:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Thursday 31 May 2012, ABRAHAM, KISHON VIJAY wrote:
>>>> > I would mark the multiplexed device compatible with "simple-bus", which
>>>> > results in the child devices automatically getting added.
>>>>
>>>> hmm.. ocp2scp has a sysconfig register and it also has a module mode
>>>> by which it can be enabled/disabled. I was making use of pm_runtime
>>>> API's to control these registers (Apart from creating child devices,
>>>> the driver also has a call to pm_runtime_enable).
>>>
>>> I see.
>>>
>>>> I'm not sure if with
>>>> "simple-bus" we'll be able to do those. I have to check on that.
>>>
>>> How about making it compatible with both "simple-bus" and something
>>> that handles the pm_runtime requirements?
>>>
>>> I don't understand enough of what needs to be done for pm_runtime
>>> across a lot of devices, but I'd hope that it should be possible
>>> to do that in a generic way based on the device definition.
>>
>> Is there already exists a generic way for handling pm_runtime
>> requirements (as simple as doing a pm_runtime_enable on a device).
>
> As you've discovered, the runtime PM core handles the parent/child
> relationships already.
>
>> So the actual problem is we have ocp2scp as parent and usb2phy and
>> usb3phy as the child device. ocp2scp has the sysconfig register and it
>> can be controlled using module mode bit (both of this can be
>> controlled by pm_runtime). Whenever usb controller(dwc3/musb) wants to
>> enable a phy, it calls an exported API in usb2/usb3 phy to enable it.
>> These API's have pm_runtime_get_sync on usb2/usb3 device which in-turn
>> calls pm_runtime_get_sync of ocp2scp because of parent->child
>> relationship (For this both usb2/usb3 phy and ocp2scp devices should
>> have called pm_runtime_enable). All I'm trying is to find a place to
>> have pm_runtime_enable for ocp2scp.
>
> Maybe I'm not following, but why can't it be in the driver?

Arnd feels it is pointless to have a driver that only does creation of
child (and pm_runtime_enable of the device). He feels it would be
better to have a generic way to do a runtime_enable of a device with
dt. (Just like how there is a generic way to create child devices by
giving .compatible as "simple-bus").

Thanks
Kishon
