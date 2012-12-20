Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab2LTTxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:53:24 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28796 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LTTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:53:18 -0500
X-IronPort-AV: E=Sophos;i="4.84,326,1355126400"; 
   d="scan'208";a="15588979"
Date: Thu, 20 Dec 2012 11:51:27 -0800
From: Pratik Patel <pratikp@codeaurora.org>
To: Jon Hunter <jon-hunter@ti.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        "magnus.p.persson@stericsson.com" <magnus.p.persson@stericsson.com>,
        "david.rusling@linaro.org" <david.rusling@linaro.org>,
        "arve@android.com" <arve@android.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "d-deao@ti.com" <d-deao@ti.com>,
        "christian.bejram@stericsson.com" <christian.bejram@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: CoreSight framework and drivers
Message-ID: <20121220195127.GA14877@pratikp-linux.qualcomm.com>
References: <1355858365-11849-1-git-send-email-pratikp@codeaurora.org>
 <20121219112314.GA26329@mudshark.cambridge.arm.com>
 <50D1F37E.6000804@ti.com>
 <20121219212431.GC23594@pratikp-linux.qualcomm.com>
 <50D34EE5.8090407@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D34EE5.8090407@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 11:46:13AM -0600, Jon Hunter wrote:
> 
> On 12/19/2012 03:24 PM, Pratik Patel wrote:
> 
> [snip]
> 
> > Currently we use the CoreSight virtual bus to conveniently list
> > sysfs configuration attributes for all the registered CoreSight
> > devices.
> > 
> > For eg:
> > /sys/bus/coresight/devices/coresight-etm0/<attribute>
> > /sys/bus/coresight/devices/coresight-etm1/<attribute>
> > /sys/bus/coresight/devices/coresight-stm/<attribute>
> > /sys/bus/coresight/devices/coresight-tmc-etf/<attribute>
> > ...
> > ...
> > 
> > Some of the attributes are based on device type (i.e. source,
> > link or sink) so they will exist for all devices of that type
> > while some are device specific.
> > 
> > Maybe I am misunderstanding the question but are you suggesting
> > to register CoreSight devices to the AMBA bus instead of the
> > CoreSight core layer code?
> 
> Yes exactly.
> 
> > Will Deacon mentioned earlier that AMBA framework can be changed
> > to accomodate devices with a different class but I am more
> > concerned with losing some of the stuff that the core layer code
> > does (eg. coresight_register, coresight_enable, coresight_disable
> > in coresight.c) if we register CoreSight drivers to the AMBA bus
> > without letting the core layer know about the device connections.
> 
> I may be missing something, but couldn't you keep all the
> register/enable/disable stuff but just register the device with the amba
> bus? Obviously some changes would need to be made.
> 

Ok, so are you referring to making CoreSight devices register
with AMBA bus instead of platform bus keeping everything else
intact?

> Personally, I don't have strong feeling either way, but we have ETM/ETB
> drivers using AMBA today and so I am hoping we can come to agreement on
> this going forward.
> 
> Russell, Will, what are your thoughts?
> 
> Otherwise, looking at the code, I like what you have implemented. I
> still need to look closer, but I am struggling to figure out how a
> coresight device such as the cross-trigger-interface fits with this
> model. This model appears to be geared towards coresight devices used
> for traces purposes and are either source, links or sinks. The
> cross-trigger-interface is not a source or a sink. However, although you
> it could be considered as a link (routing events), it is not really, as
> it may not link to other coresight sinks/source.
> 
> In my case, I have PMU-IRQ --> CTI --> GIC. So a non-coresight source
> and sink. In away the CTI looks more like a 2nd-level interrupt
> controller than anything else. Hence, another type of coresight device
> may be needed in addition to source, links and sinks. Or link is
> extended in some way to connect to non-coresight sources/sinks.
> 
> Let me know if you have any thoughts.
> 

I had left the "None" type for miscellaneous stuff but I agree it
should be a separate type - maybe "debug".

Having said that I like the CTI driver you have uploaded. Need to
look at it in more detail. Since CTI connections can vary between
chip to chip, we need a generic way to deal with it.

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
