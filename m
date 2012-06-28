Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab2F1Ro2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:44:28 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:52176 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab2F1Ro0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:44:26 -0400
Message-ID: <4FEC97F8.30903@tilera.com>
Date: Thu, 28 Jun 2012 13:44:24 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Myron Stowe <mstowe@redhat.com>
CC: Myron Stowe <myron.stowe@redhat.com>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <rth@twiddle.net>,
        <ink@jurassic.park.msu.ru>, <mattst88@gmail.com>,
        <linux@arm.linux.org.uk>, <starvik@axis.com>,
        <jesper.nilsson@axis.com>, <tony.luck@intel.com>,
        <fenghua.yu@intel.com>, <monstr@monstr.eu>, <ralf@linux-mips.org>,
        <yasutake.koichi@jp.panasonic.com>, <jejb@parisc-linux.org>,
        <deller@gmx.de>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        <lethal@linux-sh.org>, <davem@davemloft.net>, <gxt@mprc.pku.edu.cn>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <chris@zankel.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/16] tile/PCI: Factor 'pcibios_setup()' out of tile
References: <20120626033045.16434.17412.stgit@amt.stowe>  <20120626033218.16434.50584.stgit@amt.stowe>  <4FE9B6C2.7010006@tilera.com> <1340904647.2411.8.camel@zim.stowe>
In-Reply-To: <1340904647.2411.8.camel@zim.stowe>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/2012 1:30 PM, Myron Stowe wrote:
> On Tue, 2012-06-26 at 09:18 -0400, Chris Metcalf wrote:
>> On 6/25/2012 11:32 PM, Myron Stowe wrote:
>>> The PCI core provides a generic (__weak) 'pcibios_setup()' routine
>>> that can be used by all architectures as a default.  Drop tile's
>>> architecture specific version in favor of that as it does not need to be
>>> over-ridden.
>>>
>>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>>> ---
>>>
>>>  arch/tile/kernel/pci.c |   10 ----------
>>>  1 files changed, 0 insertions(+), 10 deletions(-)
>> [...]
>> In our internal tree we have x86-like support for "pci=off" here.  [...]
>> But perhaps it would make sense
>> to move the support for "pci=off" to common code, since multiple
>> architectures handle this the same way?
> Looking at the tree I only see three of the architectures currently
> using/implementing "pci=off" (four with the 'tile' addition).  Perhaps
> there is a way to avoid such but it seems like adding this to the core
> would require introducing the global variable 'pci_probe' which seems
> like unnecessary pollution?

I'd argue that the core might expose a pci_probing_disabled() function that
returns whether "pci=off" was seen, and modify the other architectures that
already support pci_probe to call that function instead.  It's true that
x86 has a much more elaborate use of pci_probe than the other
architectures, which means x86 would probably want to keep the variable
as-is and just call pci_probing_disabled() to set pci_probe to zero and return.

All that said, I'm not volunteering to make this change, so if it doesn't
seem right to you, I certainly won't insist. :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



