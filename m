Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab0HDAmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 20:42:03 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57838 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab0HDAl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 20:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gydMQjwr8LN2E75fTk+yZR4muo1R0pKjaxyUkEN874lg3YanmN9zc/WsFNI14ruepX
         cB7yUV3ndtIc9d1fTdJSMWrf6y5qJd+QO8pr67LwPd2fRL7lCrseGWdg5ryNCsAlNADb
         qQlJtrO1BOb82dZfzCPD/UbXfcKvFbtrY+9D8=
MIME-Version: 1.0
In-Reply-To: <4C58B1B6.9050005@quicinc.com>
References: <4C58A7AA.8020007@codeaurora.org>
	<20100803235631.GA17759@suse.de>
	<4C58AE15.6090900@codeaurora.org>
	<20100804000945.GA19729@suse.de>
	<4C58B1B6.9050005@quicinc.com>
Date: Tue, 3 Aug 2010 20:41:58 -0400
Message-ID: <AANLkTint-H1zcUh0dsJUt6irm_HLbiBrFi+KurOkwq8D@mail.gmail.com>
Subject: Re: [RFC PATCH] platform: Faciliatate the creation of pseduo-platform 
	busses
From: Timothy Meade <zt.tmzt@gmail.com>
To: Patrick Pannuto <ppannuto@quicinc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "dtor@mail.ru" <dtor@mail.ru>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 8:17 PM, Patrick Pannuto <ppannuto@quicinc.com> wrote:
>>>>>
>>>>>    struct platform_device sub_bus1 = {
>>>>>            .name           = "sub_bus1",
>>>>>            .id             = -1,
>>>>>            .dev.bus        = &my_bus_type,
>>>>>    }
>>>>>    EXPORT_SYMBOL_GPL(sub_bus1);
>>>>
>>>> You really want a bus hanging off of a bus?  Normally you need a device
>>>> to do that, which is what I think you have here, but the naming is a bit
>>>> odd to me.
>>>>
>>>> What would you do with this "sub bus"?  It's just a device, but you are
>>>> wanting it to be around for something.
>>>>
>>>
>>> It's for power management stuff, basically, there are actual physical buses
>>> involved that can be completely powered off IFF all of their devices are
>>> not in use. Plus it actually matches bus topology this way.
>>
>> Then create a real bus hanging off of a device, not another device that
>> "acts" like a bus here, right?  Or am I missing the point?
>>
>
> The motivation for doing it this was is that one driver could drive
> devices on two different subbusses.  In the example, "my-driver" could
> drive a device on sub_bus1 AND sub_bus2 (if there were 2+ devices, one
> or more on each bus).
>
> From my understanding, this is not possible if they are actually
> different busses.

This could be quite useful on the Qualcomm devices where there are
many collections of "devices" that resemble a bus but cannot be
directly enumerated but are initialized by platform code or possibly
in future, a device tree.  One such bus is made up of SMI devices that
are identified to the applications core by the modem firmware and can
be in the form of character devices (smd), network devices (rmnet) rpc
router channel and others, we also have to deal with the MDDI video
bus which represented a challenge when migrating the HTC Rhodium to
2.6.32 as each mdp device (and others in later kernels) are added to
the platform bus dynamically, though they don't appear similararly
group in sysfs due to not actaully being on a bus.  While it would
have been possible to implement an mddi bus, the work would have
essentially recreated the platform bus with a new name.  A simliar
challenge exists for exposing rpc endpoints to userspace as the
current codebase uses character devices rather than introducing a new
network protocol to the kernel, if such as bus was exposed through
sysfs a userspace daemon could easily bind a GPS library to the PDAPI
endpoint or similar features requiring less configuration to adapt to
new AMSS firmware or device name layout.

Thank you,
Timothy Meade
tmzt #htc-linux
facebook.com/HTCLinux
