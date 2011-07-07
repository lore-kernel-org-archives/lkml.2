Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1GGE7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 00:59:31 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:38429 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756Ab1GGE73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 00:59:29 -0400
From: Partha Basak <p-basak2@ti.com>
References: <Pine.LNX.4.44L0.1107051018580.2060-100000@iolanthe.rowland.org>
 <8762ngtyqj.fsf@ti.com> <20110706175412.GH10729@legolas.emea.dhcp.ti.com>
 <87sjqji5br.fsf@ti.com> <20110706221738.GA823@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110706221738.GA823@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw8Kox5uyub2+MfQfWzMz5KHKTY3gANqBvQ
Date: Thu, 7 Jul 2011 10:23:59 +0530
Message-ID: <94f8609ab03603c27ef2cf3850bb92e6@mail.gmail.com>
Subject: RE: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
To: balbi@ti.com, Kevin Hilman <khilman@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anand Gadiyar <gadiyar@ti.com>, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Felipe Balbi [mailto:balbi@ti.com]
>Sent: Thursday, July 07, 2011 3:48 AM
>To: Kevin Hilman
>Cc: balbi@ti.com; Alan Stern; Partha Basak; Keshava Munegowda; linux-
>usb@vger.kernel.org; linux-omap@vger.kernel.org; linux-
>kernel@vger.kernel.org; Anand Gadiyar; sameo@linux.intel.com;
>parthab@india.ti.com; tony@atomide.com; Benoit Cousson; paul@pwsan.com;
>johnstul@us.ibm.com; Vishwanath Sripathy
>Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume
>support of ehci and ohci
>
>Hi,
>
>On Wed, Jul 06, 2011 at 12:20:40PM -0700, Kevin Hilman wrote:
>> >> +	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
>> >> +	    (od->_state == OMAP_DEVICE_STATE_IDLE))
>> >> +		omap_device_enable(pdev);
>> >> +
>> >> +	return pm_generic_resume(dev);
>> >> +}
>> >> +
>> >>  static struct dev_power_domain omap_device_power_domain = {
>> >>  	.ops = {
>> >>  		.runtime_suspend = _od_runtime_suspend,
>> >>  		.runtime_idle = _od_runtime_idle,
>> >>  		.runtime_resume = _od_runtime_resume,
>> >>  		USE_PLATFORM_PM_SLEEP_OPS
>> >> +		.suspend = _od_suspend,
>> >> +		.resume = _od_resume,
>> >>  	}
>> >>  };
>> >
>> > it all depends on when are you planning to get this patch upstream.
>> > I'm considering getting some PM working on USB host and remove the
>> > pm_runtime calls from system suspend/resume either during -rc or
>> > next merge window.
>>
>> Well, IMO it's way too late for this kind of change for -rc, so I'm
>> considering it for the upcoming merge window.
>
>yes, that's true. Who should take the hwmod patches btw ? I'm still
>wondering if we should patch hwmod data first and push the _correct_ PM
>part on 3.2.

Once Kevin pushes this infrastructure enhancement, all drivers have to
rework
the Suspend/Resume anyways. Another way would be to go by the current
approach
now and then do the rework in 3.2 along with other drivers.

In this way, we can soak the Runtime support of EHCI/OHCI for one merge
window.
>
>--
>balbi
