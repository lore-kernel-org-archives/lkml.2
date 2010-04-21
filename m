Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0DUQpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:45:10 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:33641 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0DUQpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:45:07 -0400
Message-ID: <4BCF2BBA.4080708@oracle.com>
Date: Wed, 21 Apr 2010 09:45:46 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andy Isaacson <adi@hexapodia.org>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 3/3] x86,pci,acpi: Handle invalid _CRS
References: <20100409223532.GC11130@hexapodia.org> <4BCE8E3E.4030809@oracle.com> <4BCE8EBF.5050207@oracle.com> <201004210921.50502.bjorn.helgaas@hp.com>
In-Reply-To: <201004210921.50502.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BCF2B4C.016E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 08:21 AM, Bjorn Helgaas wrote:
>
>
>> +	if (pci_use_crs)
>> +		pci_bus_remove_resources(bus);
>> +
>>  	info.res_num = 0;
>>  	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
>>  				&info);
>>  
>> +	if (pci_use_crs && !info.res_num) {
>> +		/* Restore default one */
>> +		bus->resource[0] = &ioport_resource;
>> +		bus->resource[1] = &iomem_resource;
>>     
> This is ugly because it just repeats this code from pci_create_bus(),
> and there's no indication either here or there that they are connected.
>
> Admittedly, I think it's also sort of ugly that pci_bus_remove_resources()
> exists at all -- I'd rather have some sort of hook so we could set the
> bus resources correctly the first time.
>   
sure. that would be better. Can you have patch for that.
> Maybe you could at least add a pci_bus_set_default_resources() that
> could be called both here and from pci_create_bus().
>   
good idea.
> Why are you doing this patch?  Did you see a machine where the host
> bridge was left with no resources because of _CRS issues?  If so,
> this patch feels like a band-aid.  I'd rather investigate the issue
> directly, because that would probably be a Linux problem we could fix.
>
> Also, if there *is* a reported problem, you should include a link to
> the bugzilla or email thread.
>   
No, just code review.

YH
