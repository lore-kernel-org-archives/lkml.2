Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1JJJRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:17:45 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:58994 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026Ab1JJJRo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:17:44 -0400
MIME-Version: 1.0
In-Reply-To: <20111010090330.GE6685@legolas.emea.dhcp.ti.com>
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com>
	<CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com>
	<alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
	<CAP05o4KLAnNHcvNbNWqJFN710JMNAy2emYzCt2xHF+m-Kvwveg@mail.gmail.com>
	<CAP05o4+ybhZwRaXZPgS-ZdTL_0gjz1VLf6LuUtMgm_txNPwrnw@mail.gmail.com>
	<20111010090330.GE6685@legolas.emea.dhcp.ti.com>
Date: Mon, 10 Oct 2011 14:47:42 +0530
Message-ID: <CAP05o4Kqrsr3Kzm=NDpEB7wHACzXkp2mQLuWdUAsZ8pVPdJafA@mail.gmail.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: balbi@ti.com
Cc: Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 2:33 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Oct 10, 2011 at 02:22:23PM +0530, Munegowda, Keshava wrote:
>> Hi paul and Felipe
>>
>> Here is the highlights of the change in the design of  USB Host which
>> we can do after kernel 3.2 release;
>>
>> 1. separate the TLL changes  from UHH
>> 2. The TLL is be a new platform driver in ./drivers/mfd
>> 3. the TLL platform driver will export apis  for enable/disable clocks
>> and settings.
>
> TLL should control its clocks through pm_runtime APIs like anything
> else. If you really must export APIs to be used by UHH, you need to have
> an API so that you can claim/release a TLL channel and get/put for
> increasing/decreasing PM counters.
>
> I still think though, you should try to avoid exporting OMAP-specific
> APIs all over the place. Ideally, we would be able to have some way of
> saying that UHH and TLL are closely related... something like having the
> ability to say e.g. two devices are sibblings of each other, so that we
> could ask for a sibbling to wakeup/sleep depending if we need it or not.

do we have sibling structures today? I dont think so.

>
> Dunno, maybe I'm drifting here, but I don't think exposing OMAP-specific
> APIs is wise.

so, it means , if we can have sibling structure, then we can
conditionally enable it right?
