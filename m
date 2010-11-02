Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0KBOS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:18:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44075 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0KBOSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pDCfpOHrcwa8tbfAE/5TDMrLcTg7UeVOUfaP/csTVOqDaZHSyXQP4b+N18Y2bsEwJ8
         bSNd4ZcRWZRrSAdbbqV/CioiSvGULRQXr2vmrW/WCycloCe8NKXhLkXQZuw6ndgJAFA+
         CRcwZprSLnITk92M8B+N7nUk2L4PkF7BAJXGk=
MIME-Version: 1.0
In-Reply-To: <20101102141208.GU31158@pengutronix.de>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
	<1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
	<20101102131146.GA21476@opensource.wolfsonmicro.com>
	<AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
	<20101102141208.GU31158@pengutronix.de>
Date: Tue, 2 Nov 2010 16:18:18 +0200
Message-ID: <AANLkTikwGBij05h1GgW0dpvcJedmcOQ1HWCaxaBdhZta@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] drivers: cleanup Kconfig stuff
From: Felipe Contreras <felipe.contreras@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>, Mike Rapoport <mike@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/2 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> On Tue, Nov 02, 2010 at 04:02:18PM +0200, Felipe Contreras wrote:
>> On Tue, Nov 2, 2010 at 3:11 PM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
>> > On Tue, Nov 02, 2010 at 02:14:13AM +0200, Felipe Contreras wrote:
>> >
>> >>  config REGULATOR_TWL4030
>> >>       bool "TI TWL4030/TWL5030/TWL6030/TPS695x0 PMIC"
>> >>       depends on TWL4030_CORE
>> >> +     default y
>> >>       help
>> >>         This driver supports the voltage regulators provided by
>> >>         this family of companion chips.
>> >
>> > This default is not suitable for non-OMAP platforms, it should be
>> > conditional on OMAP or something if we're going to do this (though
>> > generally we handle this with defconfigs rather than in Kconfig).
>>
>> This would only be enabled when TWL4030_CORE is enabled, so non-OMAP
>> platforms would not get affected.
> Well, all platforms that have TWL4030_CORE will get REGULATOR_TWL4030 by
> default, too.  (TWL4030_CORE doesn't depend on something omapish.)

Yes, I think TWL4030_CORE should depend on OMAP3, but I think some
people might not like that. That's why I wanted to make that a
separate patch.

> For me this looks OK.  It would be still better if it removed
> CONFIG_REGULATOR_TWL4030=y from arch/arm/configs/omap2plus_defconfig.

Yes, but I want to run 'make savedefconfig'; there's many changes
lingering like that.

-- 
Felipe Contreras
