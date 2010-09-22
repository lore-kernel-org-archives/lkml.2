Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab0IVS20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:28:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42245 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab0IVS2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:28:25 -0400
Message-ID: <4C9A4AAF.3030503@zytor.com>
Date: Wed, 22 Sep 2010 11:27:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
References: <20100922172744.19085.41844.stgit@bob.kio> <4C9A42E9.7040109@zytor.com> <201009221220.34066.bjorn.helgaas@hp.com>
In-Reply-To: <201009221220.34066.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 11:20 AM, Bjorn Helgaas wrote:
> 
> These E820 ranges should be easily comparable with similar ranges we
> print elsewhere.  Currently we have things like this:
> 
>     BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>     BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>     BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
>     pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
>     pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff]
>     pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
>     reserve RAM buffer: 000000000009f400 - 000000000009ffff 
>     pnp 00:07: [mem 0xfed00000-0xfed003ff]
> 
> It would be easier to integrate the E820 information with the ACPI
> and PCI window and BAR information if they looked similar.
> 
> We currently have a mix of some with "0x" prefix, some without;
> some with eight hex digits, some with sixteen; some with spaces
> around the internal "-", some without; some with type (io/mem/etc),
> some without; some with uppercase hex (MTRR), most with lowercase;
> some including the end address, some not; and even some in PFNs
> and most in addresses.  It just makes it harder than it needs
> to be to debug issues in this area.
> 

Yes, but I think you can also see why I really don't like the thought of
the numbers in the BIOS-e820: block not even lining up anymore.

	-hpa

