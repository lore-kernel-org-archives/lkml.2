Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab2EMRLO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 13:11:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2EMRLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 13:11:13 -0400
Message-ID: <4FAFEB2D.5010009@googlemail.com>
Date: Sun, 13 May 2012 19:11:09 +0200
From: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, mturquette@ti.com
Subject: Re: [RFC] Common clock framework for external clock generators
References: <4FAB15DB.5050702@googlemail.com> <20120513122946.GD706@sirena.org.uk> <4FAFE1BF.9050805@googlemail.com> <20120513164304.GB6381@opensource.wolfsonmicro.com>
In-Reply-To: <20120513164304.GB6381@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2012 06:43 PM, Mark Brown wrote:
> One of the patches I've been sending adds a dummy clk_unregister() for
> the sake of making the drivers look nicer - practically speaking it's
> not likely to be terribly important as these things don't get unloaded
> terribly often.  It looks like that patch didn't get applied either.

Well, of course I don't plan to unload the driver ever but basically it
is possible..

One more thing I thought about: The platform I currently use needs to 
pass the external clocks to the platform devices that can use them
later. IMHO the correct way of creating clocks would be:

- register i2c clock driver and let it register its clocks with names
   like e.g. si5351, clkout0. The clock driver itself cannot and should
   not know who uses it later on.
- let drivers look for e.g. kirkwood-i2s.1, extclk because the i2s
   driver cannot know where the external clock comes from.
- have a board-specific function that configures clock hierarchy and
   create suitable clk_aliases e.g.
   si5351,clkout0 = kirkwood-i2s.1,extclk.

Currently I added a callback function pointer to the platform data
passed to the i2c clock driver that is called at the end of clock
driver probe. I doubt it will be accepted that way but can't think
of any other way..

Sebastian
