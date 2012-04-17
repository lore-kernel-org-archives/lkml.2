Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2DQFNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:13:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62548 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2DQFNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <201204162330.12178.rjw@sisk.pl>
References: <4F8790F6.5080408@intel.com>
	<201204132141.58063.rjw@sisk.pl>
	<CAC=cRTNYGGq2ncJr7mvEOm2udqXsAD3T9T=5Tafue_jrjAWCug@mail.gmail.com>
	<201204162330.12178.rjw@sisk.pl>
Date: Tue, 17 Apr 2012 13:13:39 +0800
Message-ID: <CAC=cRTMXNnZQ_bDes9JFp9yreGC63b_i9fUX6apQzWrUHw2a0Q@mail.gmail.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 5:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> +     return 0;
>> >> +}
>> >> +
>> >> +static int pcie_port_runtime_resume(struct device *dev)
>> >> +{
>> >> +     struct pci_dev *pdev = to_pci_dev(dev);
>> >> +
>> >> +     pci_restore_state(pdev);
>> >> +     if (pdev->runtime_d3cold)
>> >> +             msleep(100);
>> >
>> > What's _that_ supposed to do?
>>
>> When resume from d3cold, PCIe main link will be powered on again, it
>> will take quite some time before the main link go into L0 state.
>> Otherwise, accessing devices under the port may return wrong result.
>
> OK, but this is generic code and as per the standard the link should have been
> reestablished at this point already.
>
> Please don't put some nonstandard-platform-specific quirks like this into
> code that's supposed to handle _every_ PCIe system.

After checking PCIe spec, I found that the 100ms here has its standard origin :)

In PCI Express Base Specification Revision 2.0:

Section 6.6.1 Conventional Reset

"
To allow components to perform internal initialization, system
software must wait for at least
100 ms from the end of a Conventional Reset of one or more devices
before it is permitted to
issue Configuration Requests to those devices
"

But I think we should move the 100ms delay here to PCIe bus code or
PCIe/ACPI code, because that is needed by all PCIe devices for D3cold
support.

Best Regards,
Huang Ying
