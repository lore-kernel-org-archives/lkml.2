Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab0GMRMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:12:10 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:57593 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106Ab0GMRMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:12:08 -0400
References: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com> <20100713124840.GA16427@a1.tnic> <AANLkTimBhWKo0zxW6fX5RgLLAQVIdItS5RKpvxqkDlis@mail.gmail.com> <20100713151329.GA17516@a1.tnic>
Message-ID: <cone.1279041124.439539.3902.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Branislav Gajdos <brianzee@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: acerhdf.c - unsupported notebook
Date: Tue, 13 Jul 2010 19:12:04 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris, Hi Branislav,

Borislav Petkov writes:

> From: Branislav Gajdos <brianzee@gmail.com>
> Date: Tue, Jul 13, 2010 at 04:27:37PM +0200
> 
>> >> acerhdf: unknown (unsupported) BIOS version Acer/Aspire 3810T/V1.04,
>> >> please report, aborting!

I'm wondering, why acerhdf is even loaded for your notebook, as no 
MODULE_ALIAS matches:

[...]
MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1410*:");
MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1810*:");
MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
[...]

Which distribution do you use? Does the distribution somehow autoload acerhdf? Or do you manually load the driver?

> Peter, it looks like we support not only Atoms with that driver. Maybe
> we should check the cpu specs of the 1810T for example (and google says
> there are several different cpu types packaged with those laptops)
> before we enforce temperature limits on them...? And let me ask you
> this: are all those 1810T* entries in the bios_tbl there because of
> noisy fans ...?

Boris, I agree, we really should check the cpu specs. A quick search got me to this page: http://www.hardwaresecrets.com/article/Maximum-CPU-Temperature/143/5 where we clearly see, that the core 2 have much lower critical temperatures. 
I added all those 1410* and 1810T* entries on behalf of people telling they'd have the fan control working with these lines for some weeks without problems and I didn't care about searching for the netbooks specifications. My fault.

I would propose to enhance the bios_tbl by the default temperatures. What do you think?

thanks and kind regards,
--peter;
