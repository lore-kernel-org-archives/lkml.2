Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1JYTDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:03:21 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:57270 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1JYTDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:03:19 -0400
X-Greylist: delayed 3201 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Oct 2011 15:03:19 EDT
Message-ID: <4EA6FB6A.2020800@numascale.com>
Date: Tue, 25 Oct 2011 20:09:46 +0200
From: Arne Georg Gleditsch <arne.gleditsch@numascale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Steffen Persvold <sp@numascale.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3] Add NumaChip quirk
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com> <1318926156-25504-3-git-send-email-daniel@numascale-asia.com> <CAErSpo4Rmtd4LsXmgvb4Vn92z=u1feRyPWF=KS8ggVZvitjEnA@mail.gmail.com> <4EA6D76C.5050505@numascale.com> <CAErSpo6T8NXrHzkyHQmw3h4u5u61AZ_biF4FBf3US7FryEwhTw@mail.gmail.com> <4EA6F2F4.9080005@numascale.com>
In-Reply-To: <4EA6F2F4.9080005@numascale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25. okt. 2011 19:33, Steffen Persvold wrote:
> On 10/25/2011 19:15, Bjorn Helgaas wrote:
>> NumaChip sounds like an exception because you know you never care
>> about using those BARs.  But I'm curious -- it looks like Linux didn't
>> even try to assign resources to them.  I thought something in the
>> pci_assign_unassigned_resources() path would have tried to do
>> something with them.  If we *did* assign resources to those BARs, I
>> assume nothing would break, since there's no driver that actually uses
>> them.  Right?
>>
> 
> Correct, the BARs are there and if something sensible were written to
> them (and MemorySpace was enabled in the Command register) NumaChip
> *would* respond to mmio accesses to that address range.

A minor point: adjusting the BARs would not strictly speaking be
sufficient for the NumaChip to respond, as it would never see these
accesses unless the [MMIO address range]->[HyperTransport node/link]
registers of the CPU NorthBridges were also updated with the relevant
ranges.  This is a bit messy, but in a way much the same issue as when
secondary southbridges are connected to secondary CPUs in any other
HyperTransport-based system.

Perhaps an alternative to this NumaChip-specific quirk would be to
special-case BARs belonging to "PCI" devices 00:18 - 00:1f in AMD
Opteron systems.  These always indicate coherent HT devices and fiddling
with the CPU NB maps are going to be required if anything is changed
regarding the BAR assignments here.

-- 
							Arne.
