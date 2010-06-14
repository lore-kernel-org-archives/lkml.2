Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0FNUJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:09:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53712 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0FNUJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:09:13 -0400
Message-ID: <4C168C45.8060106@zytor.com>
Date: Mon, 14 Jun 2010 13:08:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yinghai.lu@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>, Jiri Slaby <jslaby@suse.cz>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root
 bus
References: <4BF40014.30303@ntlworld.com> <4C16777A.7060600@zytor.com> <4C167B30.2080307@oracle.com> <201006141400.22653.bjorn.helgaas@hp.com>
In-Reply-To: <201006141400.22653.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 01:00 PM, Bjorn Helgaas wrote:
>>
>> the host bridges is on AMD CPUs, 
> 
> Don't confuse the HT host bridge with the PCI host bridge.  The HT I/O spec
> is quite clear that it uses "host bridge" to refer to the HT host bridge,
> i.e., the interface between CPUs and a HyperTransport link.
> 
> I agree that the *HT host bridge* is indeed on the AMD CPU.  But that is
> certainly not the same as the PCI host bridge that bridges between an HT
> link and a PCI bus.
> 
> See sections 4.9.4 (HT host bridge) and 7.4 (HT/PCI host bridge), for
> example.
> 

>From a software point of view the latter is [largely] a PCI-to-PCI
bridge, though; it's not a root-level host bridge in the classical sense
(as noted in section 7.4).

Incidentally, in my copy of HT 3.10b, section 7.4 is marked
"HyperTransport Bridge Headers", and does not use the term "host bridge"
to refer to a secondary PCI bus.  Section 4.9.4 is simply marked "Host
Bridge".  As such, I think the HT spec is pretty consistent about
unambiguously referring to the HT host bridge when using the term "host
bridge".

	-hpa

