Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1G2Ath (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 20:49:37 -0400
Received: from void.printf.net ([89.145.121.20]:52322 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1G2Atg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 20:49:36 -0400
From: Chris Ball <cjb@laptop.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: matsumur@nts.ricoh.co.jp, ak@linux.intel.com,
        daniel.manrique@canonical.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, manoj.iyer@canonical.com,
        stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [9/50] mmc: Added quirks for Ricoh 1180:e823 lower base clock
References: <20110728234413.75CBB2403FF@tassilo.jf.intel.com>
	<OFEA694ED7.D779260D-ON492578DB.00834494-492578DC.000262D4@mta.ricoh.co.jp>
	<20110729003703.GM8006@one.firstfloor.org>
Date: Thu, 28 Jul 2011 20:47:53 -0400
In-Reply-To: <20110729003703.GM8006@one.firstfloor.org> (Andi Kleen's message
	of "Fri, 29 Jul 2011 02:37:03 +0200")
Message-ID: <m2r559di9y.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 28 2011, Andi Kleen wrote:
> On Fri, Jul 29, 2011 at 09:27:56AM +0900, matsumur@nts.ricoh.co.jp wrote:
>> Dear Sir,
>> 
>> Ricoh 1180:e823 device is named R5U220/R5U232 (2 devices have the same
>> device ID ).
>> So, I think it should be declared to as PCI_DEVICE_ID_RICOH_R5U220.
>
> Is that just the wrong name or will it actually cause misfunction?

I don't think it could possibly cause misfunction; it's just a macro name.

> BTW, does anyone know whether the current SDHCI-driver sets 200Mhz to
> SD-CLK for UHS-I cards ?

The Linux 3.1 SD driver will set the SD-CLK to 50MHz for every card on an
e823 device, and older kernels will do so too once the commit has been
applied to the stable trees.  See this commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=15bed0f2fa8e1d7db201692532c210a7823d2d21

Do you know of a better solution than always lowering the clock speed to
50MHz for this controller?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
