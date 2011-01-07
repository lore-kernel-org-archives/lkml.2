Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1AGJ7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:59:32 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:30321
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754470Ab1AGJ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:59:30 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEND2V-02-1Q6-02
X-M-MSG: 
Date: Fri, 7 Jan 2011 10:59:20 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jan Beulich <JBeulich@novell.com>
CC: "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>, JeremyFitzhardinge <jeremy@goop.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] x86: use PCI method for enabling AMD extended
	 config space before MSR method
Message-ID: <20110107095920.GO4739@erda.amd.com>
References: <4D26028F020000780002AC8A@vpn.id2.novell.com>
 <20110106172004.GM4739@erda.amd.com>
 <4D26D160020000780002AEBE@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D26D160020000780002AEBE@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.01.11 02:40:00, Jan Beulich wrote:
> >>> On 06.01.11 at 18:20, Robert Richter <robert.richter@amd.com> wrote:
> > On 06.01.11 11:57:35, Jan Beulich wrote:
> >> +#ifdef CONFIG_AMD_NB
> >> +	/* Try the PCI method first. */
> >> +	if (early_pci_allowed()) {
> >> +		unsigned int i, n;
> >> +
> >> +		for (n = i = 0; !n && amd_bus_dev_ranges[i].dev_limit; ++i) {
> >> +			u8 bus = amd_bus_dev_ranges[i].bus;
> >> +			u8 slot = amd_bus_dev_ranges[i].dev_base;
> >> +			u8 limit = amd_bus_dev_ranges[i].dev_limit;
> >> +
> >> +			for (; slot < limit; ++slot) {
> >> +				u32 val = read_pci_config(bus, slot, 3, 0);
> >> +
> >> +				if (!early_is_k8_nb(val))
> >> +					continue;
> >> +
> >> +				val = read_pci_config(bus, slot, 3, 0x8c);
> >> +				if (!(val & (ENABLE_CF8_EXT_CFG >> 32))) {
> >> +					val |= ENABLE_CF8_EXT_CFG >> 32;
> >> +					write_pci_config(bus, slot, 3, 0x8c,
> >> +							 val);
> >> +				}
> >> +				++n;
> >> +			}
> >> +		}
> >> +		pr_info("Extended Config Space enabled on %u nodes\n", n);
> > 
> > Isn't i the number of nodes?
> 
> No, "i" is the number of PCI devices looked at (but only those that
> pass early_is_k8_nb() are of interest).

Right, your code is correct.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

