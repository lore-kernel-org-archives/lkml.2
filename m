Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2HTQsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:48:04 -0400
Received: from antcom.de ([188.40.178.216]:35653 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514Ab2HTQsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:48:01 -0400
Message-ID: <50326A3E.9070607@antcom.de>
Date: Mon, 20 Aug 2012 18:47:58 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Kevin Wells <kevin.wells@nxp.com>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        "vitalywool@gmail.com" <vitalywool@gmail.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Bakki <srinivas.bakki@nxp.com>,
        "aletes.xgr@gmail.com" <aletes.xgr@gmail.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RESEND 1/2] i2c: pnx: Fix bit definitions
References: <1344411752-23469-1-git-send-email-stigge@antcom.de> <20120818095108.GB24812@pengutronix.de> <5030A81E.5090508@antcom.de> <083DF309106F364B939360100EC290F823A0354A3D@eu1rdcrdc1wx030.exi.nxp.com>
In-Reply-To: <083DF309106F364B939360100EC290F823A0354A3D@eu1rdcrdc1wx030.exi.nxp.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 06:26 PM, Kevin Wells wrote:
>>>> This patch for i2c-pnx affects PNX4008 and LPC32xx (and LPC31xx,
>>>> not yet in mainline). Can you please test and double-check the
>>>> manuals of PNX4008 and LPC31xx? I only found this via the manual
>>>> of LPC32xx but assume it's the same for the others, also.
>>>>
>>>> Thanks in advance!
>>>
>>> Kevin, since the other manuals seem to be not easily available, can
>>> you please check?
>>
>> Yes, would be great if someone at NXP could confirm that PNX actually
>> uses the same IP core for the I2C controller as LPCs do (which is
>> currently assumed by Linux anyway).
> 
> I've never had my hands on a PNX4008 chip at NXP, but I do believe they
> are the same IP. That specific I2C IP was used in a number of NXP/Phillips
> chips besides the PNX4008/LPC32xx. I don't think there are any PNX4008's in
> the wild, and even working in NXP, I can't find any non-marketing reference
> material for that part (including the user manual).

Considering this, it might be a good idea to remove support for PNX4008
(arch/arm/mach-pnx4008/) altogether. It's hard to maintain support for
hardware which isn't available, even at NXP. It would also simplify
maintenance of mach-lpc32xx because the overlap currently makes me
always wonder if the respective changes still work with mach-pnx4008.

Any opposition?

Roland


PS: I just wonder how mach-pnx4008 came into the kernel at all...
