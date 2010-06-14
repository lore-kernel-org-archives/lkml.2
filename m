Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab0FNS56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:57:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55247 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0FNS54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:57:56 -0400
Message-ID: <4C167B30.2080307@oracle.com>
Date: Mon, 14 Jun 2010 11:55:44 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
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
References: <4BF40014.30303@ntlworld.com> <4C12C189.50201@oracle.com> <4C166B4F.90308@oracle.com> <201006141234.17912.bjorn.helgaas@hp.com> <4C16777A.7060600@zytor.com>
In-Reply-To: <4C16777A.7060600@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4C167B92.0138:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 11:39 AM, H. Peter Anvin wrote:
> On 06/14/2010 11:34 AM, Bjorn Helgaas wrote:
>>
>> I made the point there that an HT chain may contain multiple HT/PCI
>> host bridges, but you are stuck on the idea that "one HT chain == one
>> PCI root bus."

should be.

>>
>> I have not found the "one PCI host bridge per HT chain" requirement
>> in the HT spec (if you find it, please point me to it).

according to my experience with LinuxBIOS. AMD chipset, nvidia and serverworks (broadcom)

>>
>> If an HT chain may contain multiple HT/PCI host bridges, then it's
>> obvious that the HT host bridge registers read by amd_bus.c don't
>> contain enough information to correctly assign address space to the
>> PCI root buses.

the host bridges is on AMD CPUs, 

>>
> 
> A HT-to-PCI bridge appears as a PCI-to-PCI bridge (i.e. a Header Type 1
> device), not as a host bridge (a Header Type 0 device).
> 
> That is at least the software model as defined.

one HT chain could have some HT devices, HT devices could be HT tunnel or HT bridge.

If it is HT tunnel, the next device will use same primary pci bus number with some addon device number.
It it is HT bridge, will like some kind pci-to-pci bridge.

link between KT890 and vt32551? is some kind va-link? it is not HT between them

somehow the southbridge vt32551 respond the sound_intel from 80:01.0... and it is supposed to be under some pci bridge.

YH
