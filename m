Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0HIGIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:08:55 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:42880 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab0HIGIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:08:54 -0400
Date: Mon, 9 Aug 2010 09:08:31 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section Mismatches
Message-ID: <20100809060831.GF2841@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20100804111156.GD19377@nokia.com>
 <20100804122659.GA13814@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100804122659.GA13814@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 02:26:59PM +0200, ext Uwe Kleine-König wrote:
>Hi Felipe,
>
>On Wed, Aug 04, 2010 at 02:11:56PM +0300, Felipe Balbi wrote:
>> I see that your commit 0db252452378aa7a9e001a13226e1cd1dc61453d removed
>> the *_driver from the symbol whitelist when referencing init section
>> (heh, it took a while), but could you explain what's the rationale
>> behind that ?
>The rational is that it's AFAIK wrong if a driver references a function
>that lives in .init.text.

how about all the driver structures ? should they remove __init from 
probe() or stop saving the probe() function's pointer ?

That can be done for e.g. platform drivers, but for cpufreq_driver 
structures, I can't see a way to avoid a section mismatch (not without 
changing the cpufreq code a bit, at least). And, to me, that init has to 
live in the .init.text section as it's pretty much only called to 
initialize the frequency table for the cpu.

>Do you think that's wrong?

no, no. Not saying that. Just wondering what will happen with several 
drivers, will they change from _driver to _ops or try to stop saving 
probe() pointers into the driver structure.

-- 
balbi

DefectiveByDesign.org
