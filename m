Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0DMVpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:45:18 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:30976 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab0DMVpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:45:16 -0400
Message-ID: <4BC4E55B.7000103@oracle.com>
Date: Tue, 13 Apr 2010 14:42:51 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andy Isaacson <adi@hexapodia.org>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH -v2 1/2] x86: Reserve [0xa0000, 0x100000] in e820 map
References: <20100409223532.GC11130@hexapodia.org>	 <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>	 <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org>	 <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>	 <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org>	 <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>	 <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com>
In-Reply-To: <4BC4DFAD.9020600@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC4E5A8.015E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 02:18 PM, H. Peter Anvin wrote:
> On 04/13/2010 02:11 PM, Yinghai wrote:
>>>
>>> I guess the real question (which I haven't looked at myself) is if the
>>> E820_RESERVED -> BUSY will cause an explicitly assigned BAR from being
>>> moved.  That's bad, not so much for this particular range, but from BARs
>>> which may be assigned by SMM.  Hacking that up in a simulator
>>> (Qemu/Bochs) and testing it is probably on the to do list...
>>
>> no, if some device BAR fall in that range, it should still use that range, and will not be relocated.
>>
>> will update the change log.
>>
> 
> Good, that's what we want.

the driver for that device later can not use pci_request_region(). because that region is BUSY already.

YH

