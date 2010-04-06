Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0DFQci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:32:38 -0400
Received: from smtp.nokia.com ([192.100.105.134]:64127 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0DFQcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:32:32 -0400
Date: Tue, 6 Apr 2010 19:32:11 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Madhusudhan <madhu.cr@ti.com>
Cc: "me@felipebalbi.com" <me@felipebalbi.com>,
       "'kishore kadiyala'" <kishorek.kadiyala@gmail.com>,
       "'Vimal Singh'" <vimal.newwork@gmail.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "svenkatr@ti.com" <svenkatr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD card's
 peformance.
Message-ID: <20100406163211.GA29117@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <v2yce9ab5791003302327hc67deb3akc7d18146534038f9@mail.gmail.com>
 <h2p7f9d1ffb1003310003z508e21dbqe37b6e1cad425866@mail.gmail.com>
 <003b01cad0f0$6ea78040$544ff780@am.dhcp.ti.com>
 <g2s7f9d1ffb1003312331o149df218g651c3e4349ac9a77@mail.gmail.com>
 <003c01cad1b1$da2cdbf0$544ff780@am.dhcp.ti.com>
 <m2n7f9d1ffb1004050556o1ed2eec8ief66d60fc85f96de@mail.gmail.com>
 <20100405164839.GB17388@gandalf>
 <007c01cad4e4$26c5a700$544ff780@am.dhcp.ti.com>
 <20100406050035.GA32537@gandalf>
 <003901cad5a4$730264d0$544ff780@am.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <003901cad5a4$730264d0$544ff780@am.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Apr 2010 16:32:22.0877 (UTC) FILETIME=[BBFE40D0:01CAD5A6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 06:16:01PM +0200, ext Madhusudhan wrote:
>
>
>> -----Original Message-----
>> From: Felipe Balbi [mailto:me@felipebalbi.com]
>> Sent: Tuesday, April 06, 2010 12:01 AM
>> To: Madhusudhan
>> Cc: me@felipebalbi.com; 'kishore kadiyala'; 'Vimal Singh';
>> tony@atomide.com; svenkatr@ti.com; linux-omap@vger.kernel.org; linux-
>> kernel@vger.kernel.org; jarkko.lavinen@nokia.com
>> Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD card's
>> peformance.
>>
>> Hi,
>>
>> On Mon, Apr 05, 2010 at 12:19:29PM -0500, Madhusudhan wrote:
>> > Since the first if command already checks for the 8-bit the second check
>> > like >= 4 is definitely not readable in my opinion.
>>
>> how come ???
>>
>> > Functionally do you see anything wrong with this patch??
>>
>> functionally no, but (hypothetical situation) and if on
>> omap4/5/6/whatever, omap controller supports a bigger bus width then
>> you'll have to add a line like:
>>
>> +	if (mmc_slot(host).wires == 16)
>> +		mmc->caps |= (MMC_CAP_16_BIT_DATA | MMC_CAP_8_BIT_DATA |
>> +				MMC_CAP_4_BIT_DATA);
>> -	if (mmc_slot(host).wires == 8)
>> +	else if (mmc_slot(host).wires == 8)
>>
>> do you see the problem ?? In my opinion it doesn't scale well.
>>
>
>The point we should note here is that MMC spec supports a max bus width of
>8-bit. So anything beyond 8-bit is not in the picture as of today.

in that case, the code could be:

WARN_ON(mmc_slot(host).wires > 8);

if (mmc_slot(host).wires == 8)
	mmc->caps |= MMC_CAP_8_BIT_DATA;
if (mmc_slot(host).wires >= 4)
	mmc->caps |= MMC_CAP_4_BIT_DATA;

-- 
balbi
