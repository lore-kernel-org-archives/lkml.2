Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2BEJQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 04:16:43 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:58567 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab2BEJQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 04:16:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120205090805.GA13300@legolas.emea.dhcp.ti.com>
References: <20120202191630.GT15343@ponder.secretlab.ca> <20120202194545.GA29351@legolas.emea.dhcp.ti.com>
 <4F2AF68D.1000505@ti.com> <20120202214907.GA22888@legolas.emea.dhcp.ti.com>
 <20120202215350.GB22888@legolas.emea.dhcp.ti.com> <4F2B078B.1040709@ti.com>
 <20120202220744.GA23092@legolas.emea.dhcp.ti.com> <87liojajs4.fsf@ti.com>
 <20120204160802.GA10818@legolas.emea.dhcp.ti.com> <CA+HSevqvHAgA+PPLm8BH5vfWkc8yY8W+fRpqjT2urq2EWtSYiA@mail.gmail.com>
 <20120205090805.GA13300@legolas.emea.dhcp.ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Sun, 5 Feb 2012 14:46:19 +0530
Message-ID: <CAMQu2gyNhEJ3vr7_o_xYAQOYKaRofJViobKtfH2HoxwgU7nUpw@mail.gmail.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
To: balbi@ti.com
Cc: "Varadarajan, Charulatha" <charu@ti.com>, Kevin Hilman <khilman@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 2:38 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Sun, Feb 05, 2012 at 12:37:55PM +0530, Varadarajan, Charulatha wrote:
>> Felipe,
>>
>> On Sat, Feb 4, 2012 at 21:38, Felipe Balbi <balbi@ti.com> wrote:

[....]

>> bank->mod_usage check is used to take care of doing pm_runtime_get*/put* only
>> if all the GPIOs in a particular bank are enabled or disabled respectively.
>
> and why should you care about that ? The first get will enable the
> resources you need, the second get will just increase a counter and so
> on. So if you have 32 gets, you will disable the module when you have 32
> puts.
>
Am not sure if it is clear to you that the GPIO resources like clock,
debounce clk are per bank wise and not per GPIO line. So doing 32
get/put per bank is stupid. runtime pm is for managing pm
resources and if the pm resource is per bank, it has to be
handled per bank.

>> With the above change, pm_runtime_put*/get* would be called for every
>> gpio_request()
>> /_free() (that is, for upto 32 pins in OMAP3/4) in a bank irrespective
>> of whether other
>
> so ?
It's useless.

>
>> GPIO pins are enabled or disabled in the same bank. Hence it is
>> required to have a
>> check based on mod_usage.
>
> unnecessary.
>
I don't think so.

Regards
Santosh
