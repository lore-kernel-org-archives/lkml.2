Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1HZGTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:19:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:53038 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1HZGTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:19:05 -0400
Message-ID: <4E573AC2.2070908@kernel.org>
Date: Thu, 25 Aug 2011 23:18:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Ralf Jung <ralfjung-e@gmx.de>, Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com> <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com> <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com> <4E56F9E5.4000005@zytor.com>
In-Reply-To: <4E56F9E5.4000005@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E573ACA.0090,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 06:41 PM, H. Peter Anvin wrote:
> On 08/25/2011 05:17 PM, Bjorn Helgaas wrote:
>>
>> If the OS allocated the next 128 bytes to another device, it sounds
>> like it would cause a conflict on Intel boxes.  This must be an area
>> that differs between vendors.  I haven't seen a spec that mentions 256
>> bytes as the required minimum MMIO size for IOAPICs, and apparently
>> the AMD IOAPIC decodes 240 bytes or fewer.
>>
> 
> For what it's worth, it's probably a bad idea on x86 for the OS to
> allocate addresses in the 0xFExxxxxx range...
> 
for system with more than one ioapic controllers, could have ioapic address rather low.
and those address are allocated to some pci devices BAR by BIOS.

Yinghai
