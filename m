Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1GUBCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 21:02:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:31260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1GUBCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 21:02:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,238,1309762800"; 
   d="scan'208";a="30112049"
Message-ID: <4E277AB3.5000100@intel.com>
Date: Thu, 21 Jul 2011 09:02:43 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Iceowl/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [BUGFIX] ACPI, APEI, EINJ Param support is disabled by default
References: <1311149369-20624-1-git-send-email-ying.huang@intel.com> <CAErSpo5-PrZ-do7HqM=2zV8cGibj0bkpFaHtmeRUJmMRZGfTWw@mail.gmail.com>
In-Reply-To: <CAErSpo5-PrZ-do7HqM=2zV8cGibj0bkpFaHtmeRUJmMRZGfTWw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2011 11:22 PM, Bjorn Helgaas wrote:
> On Wed, Jul 20, 2011 at 2:09 AM, Huang Ying <ying.huang@intel.com> wrote:
>> EINJ parameter support is only usable for some specific BIOS.
>> Originally, it is expected to have no harm for BIOS does not support
>> it.  But now, we found it will cause issue (memory overwriting) for
>> some BIOS.  So param support is disabled by default and only enabled
>> when newly added module parameter named "param_extension" is
>> explicitly specified.
> 
> Adding parameters always makes things harder for users.  Is there any
> way this could be done with a whitelist or other automatic mechanism?

The only user of EINJ is RAS developer/tester.  So we adopt a simpler
solution.

> Per 6e320ec1d98 (which added EINJ parameter support), parameters are
> an unpublished extension and are not part of the ACPI spec.  So if we
> pick up an MMIO address from a SET_ERROR_TYPE WRITE_REGISTER
> instruction and blindly fill in a structure (undefined by the spec)
> presumed to be at that address, it doesn't seem surprising that things
> will blow up on BIOSes that don't expect that behavior.  After all,
> the spec says to write to a generic address structure (not an
> einj_parameter structure) when we interpret the WRITE_REGISTER
> instruction (not at the magic time between SET_ERROR_TYPE and
> EXECUTE_OPERATION).
> 
> If EINJ parameter support is ever added to the ACPI spec, I would
> expect a new EINJ flag bit or similar indication to be added at the
> same time, so the OS would know when to use it.

EINJ parameter support has not been added to ACPI spec, it may be added
in the future, and should has some way to indicate whether parameter is
supported.

> Can you add a whitelist of BIOSes that do support this extension?
> Maybe you could define a GUID that future platforms could supply so
> you wouldn't have to update the whitelist for every new platform that
> supports it?

IMHO, the EINJ will not be used by the ordinary users.  If so, can we
use a simpler solution such as that in this patch?

Best Regards,
Huang Ying
