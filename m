Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab1IECFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 22:05:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:24570 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab1IECFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 22:05:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,330,1312182000"; 
   d="scan'208";a="48872322"
Message-ID: <4E642E76.4010309@intel.com>
Date: Mon, 05 Sep 2011 10:05:42 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Iceowl/1.0b2 Icedove/3.1.12
MIME-Version: 1.0
To: Pavel Ivanov <paivanof@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: APEI: Can not request iomem region for GARs
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com> <CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com> <4E520149.3010802@intel.com> <CAG1a4rtMnDXSGLkmwE+6N9smoghWp0W4b5-X_gogzJ9fDLTeBg@mail.gmail.com> <4E571D66.1070302@intel.com> <CAG1a4rtckCtpNjg9ApiLt4zQWArAu7N2ivoiMjueqYDRrr-G+g@mail.gmail.com> <4E5B258D.9090904@intel.com> <CAG1a4rtXhK-TtgayUDBK34kB2rEHUSN_6ZEX2B6Zg2-GprwCEA@mail.gmail.com>
In-Reply-To: <CAG1a4rtXhK-TtgayUDBK34kB2rEHUSN_6ZEX2B6Zg2-GprwCEA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2011 10:44 AM, Pavel Ivanov wrote:
> On Mon, Aug 29, 2011 at 1:37 AM, Huang Ying <ying.huang@intel.com> wrote:
>> On 08/27/2011 11:28 AM, Pavel Ivanov wrote:
>>> Also I noticed there's another suspicious message in dmesg and it was
>>> there earlier too (although it's not shown on console):
>>>
>>> GHES: Failed to enable APEI firmware first mode
>>>
>>> Is it bad? What does it mean?
>>
>> Maybe this has been fixed, please this patch,
>>
>> https://lkml.org/lkml/2011/8/11/297
> 
> Yes, this patch indeed fixed this failure message. It's now replaced by
> 
> GHES: APEI firmware first mode is enabled by WHEA _OSC.
> 
> Can I ask you another question: what does the following message mean?
> 
> [Firmware Warn]: GHES: Poll interval is 0 for generic hardware error
> source: 1, disabled.

This means:

The generic hardware error source with ID 1 is notified by poll, that
is, Linux should poll the specified address to check whether there is
hardware error report from hardware.  But the poll interval specified by
firmware is "0".  I think this should be a firmware error, and disabled
it.  I think maybe you can contact firmware vendor to fix this.

Best Regards,
Huang Ying
