Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1DOUJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:09:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51794 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab1DOUJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:09:06 -0400
Message-ID: <4DA8A5CE.2010004@zytor.com>
Date: Fri, 15 Apr 2011 13:08:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] x86: allow ZONE_DMA to be configurable
References: <alpine.DEB.2.00.1104141134260.386@chino.kir.corp.google.com> <4DA82F33.7080403@ladisch.de>
In-Reply-To: <4DA82F33.7080403@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 04:42 AM, Clemens Ladisch wrote:
> David Rientjes wrote:
>> ZONE_DMA is unnecessary for a large number of machines that do not
>> require addressing in the lower 16MB of memory because they do not use
>> ISA devices with 16-bit address registers (plus one page byte register).
>>
>> This patch allows users to disable ZONE_DMA for x86 if they know they
>> will not be using such devices with their kernel.
>> ...
>>  config ZONE_DMA
>> -	def_bool y
>> +	bool "DMA memory allocation support" if EXPERT
> 
> Better call it "ISA/LPC DMA memory allocation support".
> 
>> +	default y
> 
> Does it make sense to have this without CONFIG_ISA_DMA_API?
> 
>> +	help
>> +	  DMA memory allocation support allows old ISA devices with 16-bit
>> +	  address registers to allocate memory within the first 16MB of
>> +	  address space.  Disable if no such devices will be used.
> 
> "Old ISA devices" might be misleading because ISA does not imply actual
> ISA slots; please mention LPC devices like the floppy controller and the
> parallel port in ECP mode.
> 

This isn't really a very good edit, as ZONE_DMA isn't inherently limited
to ISA/LPC devices (and LPC devices which do LPC-native bus mastering
DMA are not affected.)  ZONE_DMA is used even for some PCI devices which
have restrictions on the DMA address mask.

	-hpa


