Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab1K3QQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:16:08 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57396 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757172Ab1K3QQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:16:06 -0500
X-Sasl-enc: H3gPMUAKWDKwe8zx1rDJH3Re9LuEo0AsNHZyepF1fzj9 1322669765
Message-ID: <4ED656F6.4080709@ladisch.de>
Date: Wed, 30 Nov 2011 17:16:54 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: DMAR:[fault reason 02] Present bit in context entry is clear
 (firewire-ohci)
References: <4BF7B147.9020502@s5r6.in-berlin.de> <20100522121212.GQ10452@parisc-linux.org> <1274553643.11551.17300.camel@macbook.infradead.org> <20100522120905.154ff932@jbarnes-x201> <20111119172127.GA31915@nomi.cz>
In-Reply-To: <20111119172127.GA31915@nomi.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomáš Janoušek wrote:
> On Sat, May 22, 2010 at 12:09:05PM -0700, Jesse Barnes wrote:
>> On Sat, 22 May 2010 19:40:43 +0100
>> David Woodhouse <dwmw2@infradead.org> wrote:
>>> [...]
>>> Yeah, the DMAR looks at the source-id in the PCIe transactions, and it
>>> sounds like those are all 04:00.0. But we've probably set up the DMAR to
>>> allow the transactions from 04:00.4, and then it naturally faults when a
>>> "different" device actually ends up doing the transaction.
>>>
>>> If you make the pci_find_upstream_pcie_bridge() function do the
>>> appropriate thing for this device, does it then work as expected?
>>>
>>> Whether that's a _sane_ thing to do or not is possibly more of a Jesse
>>> question...
>>
>> Well, if cardbus bridges tend to behave this way in general it would
>> make sense to simply use the cardbus bride id everywhere, rather than
>> the specific functions of the device.  Cc'ing Dominik.
>
> Any news on this one?

Apparently not.

Try the patch in <https://bugzilla.redhat.com/show_bug.cgi?id=605888>
that is intended to work around the bug in your Ricoh chip.  Alternatively,
disable VT-d or FireWire in the BIOS, or add the kernel parameter
"intel_iommu=off".


Regards,
Clemens
