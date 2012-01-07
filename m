Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab2AGSdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 13:33:32 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:47739 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680Ab2AGSdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 13:33:31 -0500
Message-ID: <4F088FAC.3000200@metafoo.de>
Date: Sat, 07 Jan 2012 19:32:12 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        kwangwoo.lee@gmail.com, patches@linaro.org, jg1.han@samsung.com,
        rob.herring@calxeda.com, grant.likely@secretlab.ca, cbou@mail.ru,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        rpurdie@rpsys.net, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, augulis.darius@gmail.com
Subject: Re: [PATCH] backlight: lcd: add driver for raster-type lcd's with
 gpio controlled panel reset
References: <1325778146-27056-1-git-send-email-thomas.abraham@linaro.org> <20120107182319.GA13181@n2100.arm.linux.org.uk>
In-Reply-To: <20120107182319.GA13181@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2012 07:23 PM, Russell King - ARM Linux wrote:
> On Thu, Jan 05, 2012 at 09:12:26PM +0530, Thomas Abraham wrote:
>> Add a lcd panel driver for simple raster-type lcd's which uses a gpio
>> controlled panel reset. The driver controls the nRESET line of the panel
>> using a gpio connected from the host system. The Vcc supply to the panel
>> is (optionally) controlled using a voltage regulator. This driver excludes
>> support for lcd panels that use a serial command interface or direct
>> memory mapped IO interface.
> 
> I'm trying to work out what kind of LCD panel this is for.  I assume
> not the panels which would be connected to a SoC, which have a parallel
> interface to a frame buffer device (LCD controller)?
> 
> If this is for these kinds of LCD panels, how are you handling the
> timing required for active panels - some of which must not be powered
> up without the LCD controller first being setup and enabled, and must
> be powered down before the LCD controller is disabled.
> 
> I've seen this requirement with panels connected to ARM Ltd's development
> boards, and also some SoCs.

This is handled by the LCD framework. Or at least should be, see this patchset
http://www.spinics.net/lists/linux-fbdev/msg04503.html

- Lars
