Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0DGA56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:57:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37619 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab0DGA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:57:51 -0400
Message-ID: <4BBBD87C.1040307@ti.com>
Date: Tue, 6 Apr 2010 19:57:32 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
CC: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       "'kishore kadiyala'" <kishorek.kadiyala@gmail.com>,
       "'Vimal Singh'" <vimal.newwork@gmail.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "S, Venkatraman" <svenkatr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "'Lavinen Jarkko (Nokia-D/Helsinki)'" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD card's peformance.
References: <003b01cad0f0$6ea78040$544ff780@am.dhcp.ti.com> <g2s7f9d1ffb1003312331o149df218g651c3e4349ac9a77@mail.gmail.com> <003c01cad1b1$da2cdbf0$544ff780@am.dhcp.ti.com> <m2n7f9d1ffb1004050556o1ed2eec8ief66d60fc85f96de@mail.gmail.com> <20100405164839.GB17388@gandalf> <007c01cad4e4$26c5a700$544ff780@am.dhcp.ti.com> <20100406050035.GA32537@gandalf> <003901cad5a4$730264d0$544ff780@am.dhcp.ti.com> <20100406163211.GA29117@nokia.com> <4BBB6767.7010202@ti.com> <20100406165720.GA17916@nokia.com> <00b401cad5e0$1d1868d0$544ff780@am.dhcp.ti.com> <4BBBC628.9030207@ti.com> <00c901cad5e7$9de54350$544ff780@am.dhcp.ti.com>
In-Reply-To: <00c901cad5e7$9de54350$544ff780@am.dhcp.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chikkature Rajashekar, Madhusudhan had written, on 04/06/2010 07:16 PM, 
the following:
> 
>> -----Original Message-----
>> From: Nishanth Menon [mailto:nm@ti.com]
>> Sent: Tuesday, April 06, 2010 6:39 PM
>> To: Chikkature Rajashekar, Madhusudhan
>> Cc: felipe.balbi@nokia.com; me@felipebalbi.com; 'kishore kadiyala'; 'Vimal
>> Singh'; tony@atomide.com; S, Venkatraman; linux-omap@vger.kernel.org;
>> linux-kernel@vger.kernel.org; 'Lavinen Jarkko (Nokia-D/Helsinki)'
>> Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD card's
>> peformance.
>>
>> Chikkature Rajashekar, Madhusudhan had written, on 04/06/2010 06:23 PM,
>> the following:
>>>> -----Original Message-----
>>>> From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
>>>> Sent: Tuesday, April 06, 2010 11:57 AM
>>>> To: ext Nishanth Menon
>>>> Cc: Balbi Felipe (Nokia-D/Helsinki); Chikkature Rajashekar,
>> Madhusudhan;
>>>> me@felipebalbi.com; 'kishore kadiyala'; 'Vimal Singh';
>> tony@atomide.com;
>>>> S, Venkatraman; linux-omap@vger.kernel.org; linux-
>> kernel@vger.kernel.org;
>>>> Lavinen Jarkko (Nokia-D/Helsinki)
>>>> Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD
>> card's
>>>> peformance.
>>>>
>>>> On Tue, Apr 06, 2010 at 06:55:03PM +0200, ext Nishanth Menon wrote:
>>>>> some reasons why i love switch statements ;) since I dont expect other
>>>>> than precisely 4 and 8 (do we expect 5,6,7 - i might be wrong).. but
>> if
>>>>> it is so, wont the following be better?
>>>>>
>>>>> switch (mmc_slot(host).wires)
>>>>> {
>>>>> case 8:
>>>>> 	mmc->caps |= MMC_CAP_8_BIT_DATA;
>>>>> 	/* fall thru*/
>>>>> case 4:
>>>>> 	mmc->caps |= MMC_CAP_4_BIT_DATA;
>>>>> 		break;
>>>>> default:
>>>>> 	WARN("bad width");
>>>>> }
>>>> I like that, but I remember Madhu (or someone else) saying he thinks
>>>> it's less readable this way. Go figure...
>>>>
>>> Well, I did not comment on the usage of switch here. Note we only need
>> to
>>> handle 8-bit and 4-bit.The board files need not setup 8-bit or 4-bit if
>> the
>>> configuration of that board is 1-bit. The driver will still work in 1-
>> bit
>>> mode which would mean there is nothing to do in default case and should
>> not
>>> err out.
>> check the attachment out.. hope that takes care of it.. just as a
>> reference alone ofcourse..
> 
> Nope. The default case is wrong. The assumption followed by controller
> drivers is that if the board file says 4-bit or 8-bit set the capabilities
> otherwise don't do any thing. The host will continue to work in 1-bit mode
> which is a must. Your patch violates that (can not design a board without
> connecting one data line at least :))
> 
> Also you can not say 1-bit is non-optimal because the board file dictates
> the configuration based on what it is capable of. Why through a warning?
> It is subjective.
Point noted. try n++:
switch(mmc_slot(host).wires) {
case 8:
         mmc->caps |= MMC_CAP_8_BIT_DATA;
         /* Fall through */
case 4:
         mmc->caps |= MMC_CAP_4_BIT_DATA;
         break;
case 0:
         /* assuming nothing was given by board, use 1 */
case 1:
         /* nothing to crib here */
         break;
default:
         /* Completely unexpected.. try 1 bit instead  */
         dev_crit(mmc_dev(host->mmc), "Invalid width %d"
                         " used! using 1 instead\n",
                         mmc_slot(host).wires);
}

note: we should crib if the board file made a mistake here.. say it gave 
10 wire or so.. I agree that we can recover by stepping back to 1 bit 
mode.. but we gotta tell the log that something aint right..

-- 
Regards,
Nishanth Menon
