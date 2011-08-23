Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1HWAcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:32:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:59856 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab1HWAcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,266,1312182000"; 
   d="scan'208";a="44012040"
Message-ID: <4E52F510.20700@intel.com>
Date: Tue, 23 Aug 2011 08:32:16 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Iceowl/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Pavel Ivanov <paivanof@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: APEI: Can not request iomem region for GARs
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com>	<CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>	<4E520149.3010802@intel.com>	<CAErSpo71XHyuji1HxZwShtg-YQCavgkgcdH23ic38q3COB3MgQ@mail.gmail.com> <CAE9FiQVNGpA9rE0Q7Lx2AB_+8dPEg=f98vqPx1PARkABLVYXqw@mail.gmail.com>
In-Reply-To: <CAE9FiQVNGpA9rE0Q7Lx2AB_+8dPEg=f98vqPx1PARkABLVYXqw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 05:04 AM, Yinghai Lu wrote:
> On Mon, Aug 22, 2011 at 9:45 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Mon, Aug 22, 2011 at 1:12 AM, Huang Ying <ying.huang@intel.com> wrote:
>>> Do you have time to try the patch attached with the mail?
>>> acpi_nvs.patch should go first.
>>
>> In this case, we have an ACPI NVS region, and the APEI code is
>> essentially a driver for some registers that reside there.  APEI is
>> the entity that manages those registers, and it needs to enforce
>> mutual exclusion so nobody else touches them behind its back, so I
>> think it makes sense for it to request the register regions and mark
>> them busy.
>>
>> My proposal is to change e820 so it either leaves ACPI NVS out of the
>> iomem_resource tree or puts it in but leaves it non-busy.
> 
> assume Huang Ying only tested with UEFI native boot?

No.  I tested it with legacy BIOS.  But ACPI NVS is not used by APEI on
my testing machine.

> i have one local patch for legacy mode booting, and it's similar to
> what Bjorn suggested.
> 
> Please check the attached patch.

I think we need help from ACPI guys on why ACPI NVS is marked as busy.

If my understanding were correct, ACPI NVS should not be used by OS at
all, so it is marked as busy.  But for APEI, Linux interprets some code
(instructions in ERST/EINJ table) from firmware.  I think this is
similar with AML code accessing ACPI NVS.

Hi, Len,

Do you think my understanding is correct?

Best Regards,
Huang Ying
