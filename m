Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0HIGtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:49:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49509 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab0HIGti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:49:38 -0400
Date: Mon, 9 Aug 2010 08:49:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section Mismatches
Message-ID: <20100809064936.GA14690@pengutronix.de>
References: <20100804111156.GD19377@nokia.com> <20100804122659.GA13814@pengutronix.de> <20100809060831.GF2841@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100809060831.GF2841@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe,

On Mon, Aug 09, 2010 at 09:08:31AM +0300, Felipe Balbi wrote:
> On Wed, Aug 04, 2010 at 02:26:59PM +0200, ext Uwe Kleine-König wrote:
>> Hi Felipe,
>>
>> On Wed, Aug 04, 2010 at 02:11:56PM +0300, Felipe Balbi wrote:
>>> I see that your commit 0db252452378aa7a9e001a13226e1cd1dc61453d removed
>>> the *_driver from the symbol whitelist when referencing init section
>>> (heh, it took a while), but could you explain what's the rationale
>>> behind that ?
>> The rational is that it's AFAIK wrong if a driver references a function
>> that lives in .init.text.
>
> how about all the driver structures ? should they remove __init from  
> probe() or stop saving the probe() function's pointer ?
>
> That can be done for e.g. platform drivers, but for cpufreq_driver  
> structures, I can't see a way to avoid a section mismatch (not without  
> changing the cpufreq code a bit, at least). And, to me, that init has to  
> live in the .init.text section as it's pretty much only called to  
> initialize the frequency table for the cpu.
I think they need handling similar handling like the usb gadget drivers.

See

	http://thread.gmane.org/gmane.linux.ports.ppc.embedded/37291/focus=34468

for the changes I suggested there.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
