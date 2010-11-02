Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0KBTnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 15:43:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52745 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0KBTnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 15:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jsvqoJzD7WOgu82X+x6AA0sWGSynWrJ+7nXAl1bzgZ706jZhippEChZBJlSPvU8o8b
         fiXCPmQ3rdQby07W7/guQA0Ie94+DdqX/EAKYxJ5C3G1WsdWK5EBhDC6tZjjLFtFBywG
         GyMoRr1hHF4o1Ox7+G5h7/QIG5uaDKv9JHtQ0=
MIME-Version: 1.0
In-Reply-To: <20101102143534.GG21476@opensource.wolfsonmicro.com>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
	<1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
	<20101102131146.GA21476@opensource.wolfsonmicro.com>
	<AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
	<20101102143534.GG21476@opensource.wolfsonmicro.com>
Date: Tue, 2 Nov 2010 21:43:30 +0200
Message-ID: <AANLkTimuT8__KJE1V9f8PoFCxUjYW6n=35mLH4wBVdvM@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mike Rapoport <mike@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 4:35 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Nov 02, 2010 at 04:02:18PM +0200, Felipe Contreras wrote:
>> On Tue, Nov 2, 2010 at 3:11 PM, Mark Brown
>
>> > This default is not suitable for non-OMAP platforms, it should be
>> > conditional on OMAP or something if we're going to do this (though
>> > generally we handle this with defconfigs rather than in Kconfig).
>
>> This would only be enabled when TWL4030_CORE is enabled, so non-OMAP
>> platforms would not get affected.
>
> TWL4030 can be enabled on other platforms - it's not tied to OMAP
> (mostly to enable build coverage).

Yes, but if you are manually enabling TWL4030_CORE and REGULATOR,
REGULATOR_TWL4030 makes sense. If somebody doesn't want it for some
reason, it can be manually disabled.

>> I guess you have seen the complaint from Linus regarding ARM relying
>> too much on defconfigs. This helps in order to simplify defconfigs,
>> and eventually getting rid of them completely.
>
> This solution doesn't seem like it scales so well either, it just shifts
> it into the Kconfig files (where everything is all in central files
> shared by everyone which has its own problems).  Certainly the goal of
> replacing defconfig files with Kconfig seems unattainable.

The difference is that Kconfig files are needed, and part of linux
itself. The defconfig files should be optional, there are many, and
not necessarily in the linux tree (e.g. meego kernel configs).

However, even if you forget about Kconfig vs defconfig, it should be
possible to create a .config file from nothing, and when you do that,
having REGULATOR_TWL4030 enabled when you enable REGULATOR support
just makes sense (if you have enabled TWL4030_CORE).

-- 
Felipe Contreras
