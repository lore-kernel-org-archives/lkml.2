Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1F3Uuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 16:50:44 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:38559
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751144Ab1F3Uul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 16:50:41 -0400
Message-ID: <4E0CE189.1020000@compulab.co.il>
Date: Thu, 30 Jun 2011 23:50:17 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stanislav Brabec <utx@penguin.cz>, Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, zaurus-devel@www.linuxtogo.org,
        spi-devel-general@lists.sourceforge.net, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: kernel panic in spi_complete() on spitz (PXA270)
References: <1308845380.4533.54.camel@oct.suse.cz> <201106301352.21684.marek.vasut@gmail.com> <1309445118.4406.47.camel@oct.suse.cz> <4E0C957F.8080807@compulab.co.il> <1309450406.4406.59.camel@oct.suse.cz> <4E0CB518.2080703@compulab.co.il> <20110630180105.GA5064@opensource.wolfsonmicro.com>
In-Reply-To: <20110630180105.GA5064@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/30/11 21:01, Mark Brown wrote:
> On Thu, Jun 30, 2011 at 08:40:40PM +0300, Igor Grinberg wrote:
>> On 06/30/11 19:13, Stanislav Brabec wrote:
>
>>>  I seen two
>>> proposals:
>>> - As ADS7846 hardware does not require dedicated regulator, don't
>>>   require it in driver and fail only on platforms that have a dedicated
>>>   regulator.
>> The thing is that ads7846 chip itself just requires power supply
> Right, and the regulator API hides the non-switchability of the supply
> from the driver so there's no need for the driver to worry about how the
> supplies are wired up.  It just turns the regulator on when it needs it
> and turns it off when it doesn't.
>
>>>> 1) add regulator definition for ads7846 into the board file
>>> There is no dedicated regulator on spitz, ADS7846 uses common always-on
>>> power supply.
>> Is there a kind of regulator for this case (except dummy)?
>> Some kind of fixed regulator which is not binded to any supply?
> This is just a fixed voltage regulator, support for that has been in the
> kernel since the regulator API was merged.  This is the best solution,
> it ensures that you don't mistakenly activate dummy reglators for
> supplies that really need software control.

Right, just as I thought (I still haven't made myself familiar with all the
regulator API aspects).

Stanislav,
Can't you define a fixed voltage regulator for the ads7846 in spitz board file?
This shouldn't be a hard task and is the right solution from the regulator API POV.


-- 
Regards,
Igor.

