Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041Ab2DLGr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:47:59 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:49618 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762005Ab2DLGr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:47:57 -0400
Message-ID: <4F867A95.9030104@ti.com>
Date: Thu, 12 Apr 2012 12:17:49 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Paul Walmsley <paul@pwsan.com>, Aneesh V <aneesh@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, mgreer@animalcreek.com, msalter@redhat.com
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
References: <1331934707-29487-1-git-send-email-aneesh@ti.com> <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com> <20120412030044.GA26236@kroah.com>
In-Reply-To: <20120412030044.GA26236@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2012 08:30 AM, Greg KH wrote:
> On Wed, Apr 11, 2012 at 08:44:39PM -0600, Paul Walmsley wrote:
>> Cc Mark Greer, Mark Salter
>>
>> Hi Greg, Aneesh,
>>
>> On Sat, 17 Mar 2012, Aneesh V wrote:
>>
>>> Add a driver for the EMIF SDRAM controller used in TI SoCs
>>>
>>> EMIF is an SDRAM controller that supports, based on its revision,
>>> one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
>>> for LPDDR2.
>>
>> Just checking to see what the current state of this series is.  Greg, are 
>> you considering this for merging, or are there remaining issues?  Aneesh, 
>> do you have any remaining issues to resolve with this set?
> 
> What about the review comment about devfreq?
>
Devfreq is not suitable for this driver. I already replied on this
thread [1]

Acting on frequency change is just one function of the controller
driver and that too need not bed to attached with devfreq. The driver
has features like temperature handling as per JDEC specs, active power
managements modes, system wide suspend power management like self
refresh and also configuration which can help memory hotplug for
power savings and initialising the DDR timings to avoid boot-loader
defaults.The controller IP works in conjunction with PRCM (OMAP Power
IP) block to achieve some of this functionality.

I was hoping that we will have some thing like drivers/memory/*
but since it doesn't exist, we used drivers/misc.

Regards
Santosh
[1] https://lkml.org/lkml/2012/3/19/178

>> This is useful not only for OMAP4 and AM3517/3505, but also will probably 
>> be useful for the C6x chips that Mark Salter is working on.
> 
> It's still in my "to-review" queue, that I'm slowly making my way
> through.  So it's not lost, but I would like to get the devfreq
> interface question cleared up first.
> 
Let us know if you need more clarification on devfreq part.
Thanks for looking into it.

Regards
Santosh
