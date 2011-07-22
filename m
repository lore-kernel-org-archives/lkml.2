Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1GVM1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 08:27:30 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:54483 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745Ab1GVM13 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 08:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110722122221.GG32058@legolas.emea.dhcp.ti.com>
References: <1311084703-10266-1-git-send-email-keshava_mgowda@ti.com>
	<20110722122221.GG32058@legolas.emea.dhcp.ti.com>
Date: Fri, 22 Jul 2011 17:57:26 +0530
Message-ID: <CAP05o4+RKcYPFez0xJYimugPEpPJcFoPJawW+c0hdty7YmNLAg@mail.gmail.com>
Subject: Re: [PATCH] arm: omap: usb: clock enable typo fix in usbhs driver
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, kishon@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 5:52 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Jul 19, 2011 at 07:41:43PM +0530, Keshava Munegowda wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>
> $SUBJECT is quite weird. First, this is not a patch on arch/arm/*omap*/
> so arm: omap: is already wrong. Also, "enable typo fix" is quite werid.
>
> Something like: "mfd: omap-usb-host: fix clock API usage on
> usbhs_disable()" would read better.
>
>> The usbhs_disable function was invoking clk_enable api
>> instead of clk_disable; The clk_disable is called to
>                        ^ this semicolon should be a period.
>
> ok, you're missing the actual problem here. How about you extend it to
> read as:
>
> usbhs_disable function was invoking clk_enable() instead of
> clk_disable(), thus only increasing the clock usage counter and
> preventing this particular clock from being ever turned off.
>
> Because of that, the power domain where the USB Host subsystem is
> located, would never reach lower power states.
>
>> disble the port clocks of usbhs
>    ^^ disable.
>
> --
> balbi

Thanks I will send the updated patch soon.

>
