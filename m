Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab1CaS1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:27:39 -0400
Received: from void.printf.net ([89.145.121.20]:55152 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab1CaS1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:27:38 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj <manoj.iyer@canonical.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Philip Langdale <philipl@overt.org>
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>
	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>
	<m3vcz02mi1.fsf@pullcord.laptop.org> <4D948BC4.6020904@canonical.com>
	<m3sju3z6yc.fsf@pullcord.laptop.org> <4D949298.4000701@canonical.com>
	<m3oc4rz5kp.fsf@pullcord.laptop.org> <4D94A510.4040509@canonical.com>
	<m3fwq3z1yu.fsf@pullcord.laptop.org> <4D94B552.8020108@canonical.com>
	<m3zkoburoz.fsf@pullcord.laptop.org> <4D94C0E5.6070801@canonical.com>
Date: Thu, 31 Mar 2011 14:33:19 -0400
In-Reply-To: <4D94C0E5.6070801@canonical.com> (Manoj's message of "Thu, 31 Mar
	2011 12:59:01 -0500")
Message-ID: <m3vcyzuols.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj,

On Thu, Mar 31 2011, Manoj wrote:
> Card did not mount. New dmesg is attached.

Okay.  There's nothing in the log about Ricoh, which probably means that
it bailed out early in the function.  You could add a printk to the top
of ricoh_mmc_fixup_rl5c476() if you want to be really sure that the code
there is getting a chance to run.

I think the likely conclusion is that:

(a) The Ricoh controller has a proprietary MMC function that is stealing
    MMC cards away from the SDHCI controller even though the SDHCI could
    read them if it had a chance to.

(b) We don't know how to turn the MMC controller off, because our old
    method for doing so isn't working on this new 0xe823 model.

I'm adding a few people who've touched this code to CC: in case they
have any ideas on working out how to disable the MMC function.  If you
have contact with Ricoh directly or through a vendor, please ask them
for the PCI configuration writes needed to disable the MMC function on
this model so that you can read MMC cards with the SD interface instead.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
