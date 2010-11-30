Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab0K3VSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:18:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:51788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab0K3VSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:18:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,281,1288594800"; 
   d="scan'208";a="631744771"
Message-ID: <4CF56A28.7070909@linux.intel.com>
Date: Tue, 30 Nov 2010 13:18:32 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mitch Bradley <wmb@firmworks.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Scott Wood <scottwood@freescale.com>, Sebastian@www.tglx.de,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [sodaville] [PATCH 03/11] x86/dtb: Add a device tree for CE4100
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>	<1290706801-7323-4-git-send-email-bigeasy@linutronix.de>	<1290808645.32570.158.camel@pasglop>	<20101128160449.GC30784@www.tglx.de>	<1290984809.32570.208.camel@pasglop>	<20101129130720.7d060e1c@udp111988uds.am.freescale.net>	<1291061128.32570.298.camel@pasglop>	<4CF40DF4.9060204@firmworks.com> <20101129234259.586eb27a@lxorguk.ukuu.org.uk>
In-Reply-To: <20101129234259.586eb27a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 03:42 PM, Alan Cox wrote:
>> The usual layout is that the PCI bus is a direct child of
>> the root node, and the ISA bus is a child of the PCI bus.
>> That reflects the "Northbridge + Southbridge" wiring that
> 
> That isn't strictly true either. On many PC devices the ISA bus (or LPC
> bus nowdays) has no heirarchy as such because ISA cycles get issued if
> the PCI cycles don't generate a response. In addition some cycles go to
> both busses on some chipsets and there are various bits of magic so the
> I/O spaces and particularly the memory spaces are intertwined.
> 
> So it's not a subordinate bus really, its a bit weirder. PCMCIA is
> probably a sub-bus when you've got a PCI/PCMCIA adapter but ISA in
> general is a bit fuzzy.
> 

Actually, it can go both ways -- there are ISA/LPC busses which are true
childs of PCI busses -- in particular, are subject to the decoding
restrictions of the host bridge -- and there are those that aren't
logically even if they are physically.  The reason for this is that
subtractive decoding can be done either at the back end (as in a classic
PCI/ISA system with a single PCI bus) or at the front end (as in
HyperTransport for example.)

	-hpa
