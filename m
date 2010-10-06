Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab0JFTrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:47:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:54812 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759257Ab0JFTrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:47:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,292,1283756400"; 
   d="scan'208";a="614063564"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Wed, 6 Oct 2010 12:47:43 -0700
Subject: RE: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
 time as methods
Thread-Topic: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
 time as methods
Thread-Index: ActljRUPBxkai0DKRh64GrFetol94gAAepPw
Message-ID: <4911F71203A09E4D9981D27F9D830858B4893EB3@orsmsx503.amr.corp.intel.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
 <4911F71203A09E4D9981D27F9D830858B4893B89@orsmsx503.amr.corp.intel.com>
 <20101006161854.GA30584@srcf.ucam.org> <201010062130.27564.rjw@sisk.pl>
In-Reply-To: <201010062130.27564.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I would suggest we add a device object to can_wake. This allows the acpica core to handle this "implicit notify" with no additional overhead from the host.



>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>Sent: Wednesday, October 06, 2010 12:30 PM
>To: Matthew Garrett
>Cc: Moore, Robert; linux-acpi@vger.kernel.org; linux-
>kernel@vger.kernel.org; linux-pci@vger.kernel.org
>Subject: Re: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
>time as methods
>
>On Wednesday, October 06, 2010, Matthew Garrett wrote:
>> On Wed, Oct 06, 2010 at 09:14:07AM -0700, Moore, Robert wrote:
>>
>> > Although there exists a single Windows document mentions this behavior
>as a windows "feature", I'm not 100% convinced that this is actually true.
>AFAIK, we've never seen a machine that depends on an "implicit notify" on a
>device when a wake GPE happens.
>>
>> Such behaviour would be irrelevant for system sleep/wake - the only
>> requirement is in runtime power management.
>>
>> > It appears to me that the biggest issue right now is the fact that a
>Notify() must be performed on a Device object, and the problem is how to
>associate the GPE with the device object.
>>
>> The other important aspect of this is that a single GPE may correspond
>> to multiple devices. The methods will generally cope with this by either
>> sending multiple notifies, executing some SMM code to identify the
>> relevant device or reading PCI configuration registers to identify the
>> source of the wakeup. We need to handle that case as well.
>
>So, as I said, we can modify acpi_gpe_can_wake() to pass a device object to
>ACPICA.  Then, the device object will be added to the list of devices to
>Notify()
>if the GPE is signaled.  Plain and simple.
>
>Thanks,
>Rafael
