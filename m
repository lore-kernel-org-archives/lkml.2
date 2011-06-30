Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1F3P0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:26:36 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:50606
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751541Ab1F3P0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:26:34 -0400
Message-ID: <4E0C957F.8080807@compulab.co.il>
Date: Thu, 30 Jun 2011 18:25:51 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stanislav Brabec <utx@penguin.cz>
CC: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
        zaurus-devel@www.linuxtogo.org,
        spi-devel-general@lists.sourceforge.net, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com
Subject: Re: kernel panic in spi_complete() on spitz (PXA270)
References: <1308845380.4533.54.camel@oct.suse.cz>	 <201106301352.21684.marek.vasut@gmail.com> <1309445118.4406.47.camel@oct.suse.cz>
In-Reply-To: <1309445118.4406.47.camel@oct.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/11 17:45, Stanislav Brabec wrote:

> Marek Vasut wrote:
>> On Thursday, June 23, 2011 06:09:40 PM Stanislav Brabec wrote:
>>> Hallo.
>>>
>>> These Oops and kernel panic were observed on a Zaurus (spitz) machine
>>> (ARMv5, PXA270).
>> Looks similar to "Re: [PATCH v2] Input: Make ADS7846 independent on regulator"
> I don't see any trace in that thread. But yes, I was testing your patch
> from this thread. Without it, ADS7846 does not work on spitz (ADS7846
> does not have any dedicated regulator there). I want to
> add .needs_regulator bool to ads7846.c and send the patch again to the
> list.

Please, don't...
I thought we've finished discussing the regulator issue...

Instead of patching the driver and the platform data and the board file,
you should do _either_ of the following:
1) add regulator definition for ads7846 into the board file
2) enable the CONFIG_REGULATOR_DUMMY in your kernel configuration
3) use regulator_use_dummy_regulator() call in the board file.

Using either of the above, you will not need the patch for ads7846, only for the board file.


-- 
Regards,
Igor.

