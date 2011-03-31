Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab1CaOhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:37:33 -0400
Received: from void.printf.net ([89.145.121.20]:58656 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479Ab1CaOhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:37:32 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj <manoj.iyer@canonical.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>
	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>
	<m3vcz02mi1.fsf@pullcord.laptop.org> <4D948BC4.6020904@canonical.com>
Date: Thu, 31 Mar 2011 10:43:23 -0400
In-Reply-To: <4D948BC4.6020904@canonical.com> (Manoj's message of "Thu, 31 Mar
	2011 09:12:20 -0500")
Message-ID: <m3sju3z6yc.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj,

On Thu, Mar 31 2011, Manoj wrote:
>> There's no sign of life at all from the card.  Have you tried another
>> MMC card to verify that this one isn't broken?  Or the quirks?
>
> Yes, tried it all, I have tried MMC, MMCplus, and quirks. I get the
> same result. At the same time it sees SDHCI just fine.

How about setting CONFIG_MMC_RICOH_MMC?

config MMC_RICOH_MMC
        bool "Ricoh MMC Controller Disabler  (EXPERIMENTAL)"
        depends on MMC_SDHCI_PCI
        help
          This adds a pci quirk to disable Ricoh MMC Controller. This
          proprietary controller is unnecessary because the SDHCI driver
          supports MMC cards on the SD controller, but if it is not
          disabled, it will steal the MMC cards away - rendering them
          useless. It is safe to select this even if you don't
          have a Ricoh based card reader.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
