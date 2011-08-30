Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab1H3A5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 20:57:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:22904 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1H3A5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 20:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,299,1312182000"; 
   d="scan'208";a="43721490"
Message-ID: <4E5C356A.7000701@intel.com>
Date: Tue, 30 Aug 2011 08:57:14 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Pavel Ivanov <paivanof@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: APEI: Can not request iomem region for GARs
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com> <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com> <4E520149.3010802@intel.com> <CAG1a4rtMnDXSGLkmwE+6N9smoghWp0W4b5-X_gogzJ9fDLTeBg@mail.gmail.com> <4E571D66.1070302@intel.com> <CAErSpo5L1X49hfeJ69o_hwfuzMT6R+7TKhGbYCkyqtqVpf4tEw@mail.gmail.com> <4E5AEAF4.3000800@intel.com> <CAErSpo7=SZ1XKBY0dDUg-c+_d-GoZF7uNypQc3Ecm+iofkXTMA@mail.gmail.com>
In-Reply-To: <CAErSpo7=SZ1XKBY0dDUg-c+_d-GoZF7uNypQc3Ecm+iofkXTMA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 10:48 PM, Bjorn Helgaas wrote:
> On Sun, Aug 28, 2011 at 7:27 PM, Huang Ying <ying.huang@intel.com> wrote:
>> On 08/26/2011 09:43 PM, Bjorn Helgaas wrote:
>>> On Thu, Aug 25, 2011 at 10:13 PM, Huang Ying <ying.huang@intel.com> wrote:
>>>> Hi, Pavel,
>>>>
>>>> Sorry,  there is a minor issue in the patch.  Do you have time to try
>>>> the updated version attached.
>>>
>>> I think Yinghai's patch is a better approach (though it needs a changelog).
>>>
>>> The ACPI NVS space should not be marked as "busy" by the e820 code in
>>> the iomem_resource tree.
>>>
>>> It's way too complicated to mess around with registering NVS space and
>>> trying to deal with it specially in APEI.
>>
>> ACPI NVS is different, it can be used only by firmware, and its
>> interpreter, such as ACPI AML interpreter and APEI interpreter.  It can
>> not be used by ordinary driver.  If my understanding is correct, this is
>> why ACPI NVS is marked as busy.
> 
> I don't understand why ACPI NVS is different.  If we reserve it in
> iomem_resource (without marking it busy), it's already unavailable to
> anything else unless you know something connected to the NVS region.

I think ACPI NVS can be seen as reserved by ACPI or firmware
interpreter.  So that, all other drivers should not access it.

Best Regards,
Huang Ying
