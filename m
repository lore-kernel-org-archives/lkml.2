Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab1IUBnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 21:43:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:20761 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab1IUBnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 21:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,414,1312182000"; 
   d="scan'208";a="53817493"
Message-ID: <4E794154.6000605@intel.com>
Date: Wed, 21 Sep 2011 09:43:48 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Iceowl/1.0b2 Icedove/3.1.13
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 4/8] ACPI, APEI, Resolve false conflict between ACPI NVS
 and APEI
References: <1316482741-21799-1-git-send-email-ying.huang@intel.com> <1316482741-21799-5-git-send-email-ying.huang@intel.com> <CAErSpo4_syhxOi8jGo5oyrWBimsO7PdsXEky1vwPY_130OuPMA@mail.gmail.com> <4E77FBA4.3080907@intel.com> <CAErSpo5pUY8g7U0NeUe+Yf+R8kraExZN3Sheo6h+fb9B+RO7rw@mail.gmail.com>
In-Reply-To: <CAErSpo5pUY8g7U0NeUe+Yf+R8kraExZN3Sheo6h+fb9B+RO7rw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 12:26 AM, Bjorn Helgaas wrote:
> On Mon, Sep 19, 2011 at 8:34 PM, Huang Ying <ying.huang@intel.com> wrote:
>> On 09/20/2011 10:09 AM, Bjorn Helgaas wrote:
>>> On Mon, Sep 19, 2011 at 7:38 PM, Huang Ying <ying.huang@intel.com> wrote:
>>>> Some firmware will access memory in ACPI NVS region via APEI.  That
>>>> is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
>>>> region.  The original resource conflict checking in APEI code will
>>>> check memory/ioport accessed by APEI via general resource management
>>>> mech.  But ACPI NVS region is marked as busy already, so that the
>>>> false resource conflict will prevent APEI ERST/EINJ to work.
>>>>
>>>> To fix this, this patch excludes ACPI NVS regions when APEI components
>>>> request resources.  So that they will not conflict with ACPI NVS
>>>> regions.
>>>
>>> I think this is much, much too complicated.
>>>
>>> Yinghai's three-line e820.c patch to leave ACPI NVS regions in the
>>> iomem_resource tree, but as not busy, is far better.
>>
>> ACPI NVS should only be used by firmware or firmware interpreter instead
>> of the ordinary drivers.  So I think that is reasonable to make it busy
>> in iomem resource tree.
> 
> "My driver is not like ordinary drivers" is a common excuse for adding
> special cases. I don't buy it.
> 
> These patches (3 and 4) add a lot of complexity but I don't believe
> they add any real protection.
> 
> Regions are marked busy by their owners, i.e., by drivers that claim
> devices and know how to operate them.  The e820 code is not an owner
> of ACPI NVS regions, so it should not mark them busy.
> 
> I don't really think we have a problem here that needs to be solved.
> Ordinary drivers have no way of learning an address in ACPI NVS, so
> they aren't even going to try to use it.

So what resource conflict checking is for?  If something wrong with
driver configuration, resource description in ACPI table etc, the driver
may request iomem inside ACPI NVS regions.

ACPI NVS regions already have a user, that is the ACPI AML interpreter,
so it is always busy.

Best Regards,
Huang Ying
