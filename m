Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1HVFnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 01:43:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:48323 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1HVFnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 01:43:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,261,1312182000"; 
   d="scan'208";a="42533091"
Message-ID: <4E51EC8E.7040304@intel.com>
Date: Mon, 22 Aug 2011 13:43:42 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Iceowl/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Pavel Ivanov <paivanof@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: APEI: Can not request iomem region for GARs
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com> <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
In-Reply-To: <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2011 05:48 AM, Bjorn Helgaas wrote:
> On Tue, Aug 16, 2011 at 9:43 PM, Pavel Ivanov <paivanof@gmail.com> wrote:
>> Ever since I switched from kernel 2.6.38 to 3.0 and later versions I
>> always get the following error message on each boot:
>>
>> [    2.844242] APEI: Can not request iomem region
>> <00000000bf7b522a-00000000bf7b522c> for GARs.
>>
>> If it was only in dmesg I wouldn't even notice it. But it's always
>> printed on the console which is kind of annoying.
>> I don't quite understand what this message is about and couldn't find
>> anything on the internet. Does this message mean some error that I
>> could fix? If no, is there any way I can suppress it (besides lowering
>> the error level of messages printed on console, of course)?
> 
> [+cc Huang Ying, APEI author]
> 
> BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
> APEI: Can not request iomem region <00000000bf7b522a-00000000bf7b522c> for GARs.
> 
> This register is in the ACPI NVS region, which is type E820_NVS (not
> E820_RESERVED), so e820_reserve_resources() reserves it as
> IORESOURCE_BUSY.  My guess is that Huang tested this on machines where
> the EINJ/ERST registers are in "reserved" regions, not ACPI NVS
> regions.  The "reserved" regions are not marked IORESOURCE_BUSY.
> 
> Huang, when you fix this, please include something like the following
> (mangled) patch so the error message is more consistent with other
> resource messages.

The patch looks good.  Can you resubmit it with changelog?

> Could you also remove the ERST/EINJ/HEST "Table is not found"
> messages?  As far as I can tell, these tables are optional, and
> printing the message is confusing to users, e.g.,
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/599715

Yes.  This seems confusing to them.  I will change this.

Best Regards,
Huang Ying

