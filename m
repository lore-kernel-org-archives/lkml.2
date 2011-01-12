Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1ALRT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:19:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:23291 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab1ALRTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:19:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,313,1291622400"; 
   d="scan'208";a="696084743"
Message-ID: <4D2DE2B9.2000607@linux.intel.com>
Date: Wed, 12 Jan 2011 09:19:53 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH 10/15] x86/ioapic: Add OF bindings for	IO-APIC
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>	<1292600033-12271-11-git-send-email-bigeasy@linutronix.de>	<20110111235353.GG2131@angua.secretlab.ca> <20110112170707.GA6907@www.tglx.de>
In-Reply-To: <20110112170707.GA6907@www.tglx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 09:07 AM, Sebastian Andrzej Siewior wrote:
>>
>> I'm confused here.  Are there multiple ioapic's described by a single
>> device tree node?
> 
> Yes, the CE4100 has two IO-APICs. It looks like the first one is
> responsible for the "legacy devices" (like RTC) and the second one is
> used for the "extra devices" like SPI controller, USB, ... The UART
> however is not on the first IO-APIC but on the second.
> 
> Those two IO-APICs are not cascaded. The device tree contains the line
> number of device to the io apic. The kernel computes then interrupt
> number based on gsi_base + line_number where gsi_base is incremented by
> the number of entries[0]. This interrupt number (gsi_base + line) is then
> sent via apic bus to lapic which reports it as the active interrupt
> source.
> 

That's normal multiple IOAPIC behavior (and multiple IOAPICs is a common
thing), but why use the same device tree node for both?

	-hpa
