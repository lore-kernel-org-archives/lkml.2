Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2DEJfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:35:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40020 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab2DEJfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:35:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6670"; a="179091857"
Message-ID: <4F7D6746.9020504@codeaurora.org>
Date: Thu, 05 Apr 2012 15:05:02 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jean Pihet <jean.pihet@newoldbits.com>
CC: "Cousson, Benoit" <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-omap@vger.kernel.org, Jean Pihet <j-pihet@ti.com>,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/9] ARM: OMAP2+: SmartReflex: move the driver specific
 macros in include/linux/power
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com> <1332173578-27422-3-git-send-email-j-pihet@ti.com> <4F7C9C89.9080605@codeaurora.org> <4F7CA3E1.2050809@ti.com> <4F7D4165.2060101@codeaurora.org> <CAORVsuVt5uj5NAsqsce+7f=xMXC9-nck5cPUCOEC8QP3VkxYyA@mail.gmail.com>
In-Reply-To: <CAORVsuVt5uj5NAsqsce+7f=xMXC9-nck5cPUCOEC8QP3VkxYyA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

>
> The initial motivation is to provide a generic framework for this type
> of drivers, by cleaning up the current OMAP code and by providing as
> much generic code as possible.
>
> Cf. the patch sets I submitted before this very one:
> - the SR code clean-up [1], which is needed to make the code ready for
> the integration of new features,
> - the SR class support [2], which is needed for new SR classes to be
> implemented.
>
>  From the maintainer point of view it made more sense to move the code
> before cleaning it up and so it should happen before [1] and [2].
> The result is that [1] and [2] will need to be rebased when the move
> is accepted and merged in.
>
> [1] http://marc.info/?l=linux-omap&m=133055488908132&w=2
> [2] http://marc.info/?l=linux-omap&m=133163445926544&w=2

I am going through your patches and including some wiki pages. I 
understand the SR can be connected in two ways - intelligent and dumb :)
For intelligent I mean you just configure SR and it will and program 
PMIC, whereas in dumb scenarios application processor gets the 
notification and then it goes and writes into PMIC based on some 
floor/ceiling values. In the first case not much of apps. s/w but in the 
later case whole lot.

>
>>>
>>> Where will you put that otherwise?
>>
>>
>> Couple of suggestions:
>>
>> drivers/platform/omap/avs?
>> drivers/misc/omap/avs?
>>
>> I prefer first one.
> Those paths are for OMAP specific code and not for a generic framework.
>
>>>
>>> IIRC, David Brownell was referring to the rule of three for such case.
>>> Meaning that it worth having a generic fmwk when at least three
>>> different drivers are doing the same kind of things.
>
> Do OMAP v1 and OMAP v2 implementations count as 2 drivers? ;-)
> More seriously, the OMAP code for SmartReflex is far from complete in
> mainline. There is a plan to provide the following features:
> - OMAP v1 IP,
> - OMAP v2 IP,
> - class 1.5,
> - class 3,
> - class 3.5,
> - and more support for the upcoming chipsets.

I don't understand much of these versions right now, but hopefully after 
going through all these docs. My only contention point is to not create 
any directory into the drivers/power, unless it is generic fwk and then 
build up "client" drivers on top of it. Meanwhile we could move this 
driver into above options as I have suggested.

---Trilok Soni

-- 
--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
