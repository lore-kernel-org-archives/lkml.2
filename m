Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1ITCeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 22:34:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:28866 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1ITCeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 22:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="50120395"
Message-ID: <4E77FBA4.3080907@intel.com>
Date: Tue, 20 Sep 2011 10:34:12 +0800
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
References: <1316482741-21799-1-git-send-email-ying.huang@intel.com> <1316482741-21799-5-git-send-email-ying.huang@intel.com> <CAErSpo4_syhxOi8jGo5oyrWBimsO7PdsXEky1vwPY_130OuPMA@mail.gmail.com>
In-Reply-To: <CAErSpo4_syhxOi8jGo5oyrWBimsO7PdsXEky1vwPY_130OuPMA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 10:09 AM, Bjorn Helgaas wrote:
> On Mon, Sep 19, 2011 at 7:38 PM, Huang Ying <ying.huang@intel.com> wrote:
>> Some firmware will access memory in ACPI NVS region via APEI.  That
>> is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
>> region.  The original resource conflict checking in APEI code will
>> check memory/ioport accessed by APEI via general resource management
>> mech.  But ACPI NVS region is marked as busy already, so that the
>> false resource conflict will prevent APEI ERST/EINJ to work.
>>
>> To fix this, this patch excludes ACPI NVS regions when APEI components
>> request resources.  So that they will not conflict with ACPI NVS
>> regions.
> 
> I think this is much, much too complicated.
> 
> Yinghai's three-line e820.c patch to leave ACPI NVS regions in the
> iomem_resource tree, but as not busy, is far better.

ACPI NVS should only be used by firmware or firmware interpreter instead
of the ordinary drivers.  So I think that is reasonable to make it busy
in iomem resource tree.

Best Regards,
Huang Ying
