Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0HDASB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 20:18:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22710 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0HDAR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 20:17:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6063"; a="49777527"
X-IronPort-AV: E=Sophos;i="4.55,311,1278313200"; 
   d="scan'208";a="495133"
Message-ID: <4C58B1B6.9050005@quicinc.com>
Date: Tue, 3 Aug 2010 17:17:58 -0700
From: Patrick Pannuto <ppannuto@quicinc.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Patrick Pannuto <ppannuto@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "dtor@mail.ru" <dtor@mail.ru>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] platform: Faciliatate the creation of pseduo-platform
 busses
References: <4C58A7AA.8020007@codeaurora.org> <20100803235631.GA17759@suse.de> <4C58AE15.6090900@codeaurora.org> <20100804000945.GA19729@suse.de>
In-Reply-To: <20100804000945.GA19729@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>
>>>> 	struct platform_device sub_bus1 = {
>>>> 		.name		= "sub_bus1",
>>>> 		.id		= -1,
>>>> 		.dev.bus	= &my_bus_type,
>>>> 	}
>>>> 	EXPORT_SYMBOL_GPL(sub_bus1);
>>>
>>> You really want a bus hanging off of a bus?  Normally you need a device
>>> to do that, which is what I think you have here, but the naming is a bit
>>> odd to me.
>>>
>>> What would you do with this "sub bus"?  It's just a device, but you are
>>> wanting it to be around for something.
>>>
>>
>> It's for power management stuff, basically, there are actual physical buses
>> involved that can be completely powered off IFF all of their devices are
>> not in use. Plus it actually matches bus topology this way.
> 
> Then create a real bus hanging off of a device, not another device that
> "acts" like a bus here, right?  Or am I missing the point?
> 

The motivation for doing it this was is that one driver could drive
devices on two different subbusses.  In the example, "my-driver" could
drive a device on sub_bus1 AND sub_bus2 (if there were 2+ devices, one
or more on each bus).

>From my understanding, this is not possible if they are actually
different busses.
