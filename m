Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2IYJBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:01:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47142 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab2IYJBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:01:53 -0400
Date: Tue, 25 Sep 2012 11:01:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tero Keski-Valkama <tero.keski-valkama@neter.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Added support for Acer Aspire 5755G fan control.
Message-ID: <20120925090151.GB1247@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tero Keski-Valkama <tero.keski-valkama@neter.fi>,
	linux-kernel@vger.kernel.org
References: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
 <CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:34:13AM +0300, Tero Keski-Valkama wrote:
> This patch is a patch to add support for Acer Aspire 5755G fan control
> to acerhdf module for the latest BIOS version available in the Acer
> web site, V1.20.
> 
> <DSDT disassembly dump>
> ...
> Offset (0xA7),
> OSTT,   8,
> OSST,   8,
> THLT,   8,
> TCNL,   8,
> MODE,   1,
>     ,   2,
> INIT,   1,
> FAN1,   1,
> FAN2,   1,
> FANT,   1,
> SKNM,   1,
> SDTM,   8,
> FSSN,   4,
> FANU,   4,
> ...
> </DSDT disassembly dump>
> 
> By experiment it was found that setting the register address 0xAB to
> 0x00 (FAN1 -> 0) caused the fan to stop, and setting it to the
> original value of 0x08 (FAN1 -> 1) caused the fan to operate
> automatically in BIOS control.
> 
> By observation the value in the Embedded Controller table which
> correlated best with the temperature, and changes up and down along
> with real temperature was the register address 0xB4 (SKTC).
> 
> This patch and related evidence and dumps were sent to the original
> authors of the module, peter and bp.
> 
> The original author of the patch: Tero Keski-Valkama

No need for that - the Signed-off-by and patch authorship annotation in
git says that already.

> 
> Signed-off-by: Tero Keski-Valkama <tero.keski-valkama@neter.fi>

But before we go with this any further: you mentioned some issues still
with acerhdf - you don't want to turn off your fan but to turn it to
full?

I think in this case, you want to simply not load the driver and use the
BIOS settings, no?

-- 
Regards/Gruss,
    Boris.
