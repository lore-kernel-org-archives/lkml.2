Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0KBOC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:02:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38864 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab0KBOCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SHfXP4coeNPwTdmIdQ2dqqMF5wGHT8SZSlouzaPUfLyhm13bRnbHwyjrrJTCUyoxg+
         V3LcXnzAfLL9pVnevgnf8ayGFT4Clw7ztdqOVdJa3gBTstdXA+XDxnC8Gqry5rrW6GUZ
         Yl3PNq9tU8G7k+al+hRQxLQxmHpa8kdNKkeCs=
MIME-Version: 1.0
In-Reply-To: <20101102131146.GA21476@opensource.wolfsonmicro.com>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
	<1288656853-4625-3-git-send-email-felipe.contreras@gmail.com>
	<20101102131146.GA21476@opensource.wolfsonmicro.com>
Date: Tue, 2 Nov 2010 16:02:18 +0200
Message-ID: <AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
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

On Tue, Nov 2, 2010 at 3:11 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Nov 02, 2010 at 02:14:13AM +0200, Felipe Contreras wrote:
>
>>  config REGULATOR_TWL4030
>>       bool "TI TWL4030/TWL5030/TWL6030/TPS695x0 PMIC"
>>       depends on TWL4030_CORE
>> +     default y
>>       help
>>         This driver supports the voltage regulators provided by
>>         this family of companion chips.
>
> This default is not suitable for non-OMAP platforms, it should be
> conditional on OMAP or something if we're going to do this (though
> generally we handle this with defconfigs rather than in Kconfig).

This would only be enabled when TWL4030_CORE is enabled, so non-OMAP
platforms would not get affected.

I guess you have seen the complaint from Linus regarding ARM relying
too much on defconfigs. This helps in order to simplify defconfigs,
and eventually getting rid of them completely.

-- 
Felipe Contreras
