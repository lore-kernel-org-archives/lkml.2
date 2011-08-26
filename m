Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1HZSWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:22:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60172 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab1HZSWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:22:23 -0400
Message-ID: <4E57E441.6030800@zytor.com>
Date: Fri, 26 Aug 2011 11:21:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Ralf Jung <ralfjung-e@gmx.de>, Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com> <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com> <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com> <20110826062224.GA3903@sun> <CAErSpo66U-La7AXCraENWOUvQAuCECRT_eGvJmxC-S4BrN=yAA@mail.gmail.com> <20110826180930.GA1930@sun>
In-Reply-To: <20110826180930.GA1930@sun>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 11:09 AM, Cyrill Gorcunov wrote:
> 
> Yes, one of the spec is Intel's MP specification (as far as I remember).
> Letme re-check...
> 
>  | 3.6.5 APIC Memory Mapping
>  |
>  | "Unlike the local APICs, the I/O APICs are mapped to give shared access from all
>  | processors, providing full symmetric I/O access. The default base address for the
>  | first I/O APIC is 0FEC0_0000h. Subsequent I/O APIC addresses are assigned in
>  | 4K increments. For example, the second I/O APIC is at 0FEC0_1000h. Non-default
>  | APIC base addresses can be used if the MP configuration table is provided.
>  | (Refer to Chapter 4.) However, the local APIC base address must be aligned
>  | on a 4K boundary, and the I/O APIC base address must be aligned on a 1K
>  | boundary."
> 
> Ie -- 4K increment with 1K base address. If I find other sources I have in mind
> I'll ping you.
> 

OK, so that explicitly specifies a 1K alignment.  The 4K bit seems to be
a default policy and not a requirement.

	-hpa

