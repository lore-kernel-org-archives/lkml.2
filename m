Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1FQA5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:57:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:16167 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab1FQA5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:57:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,378,1304319600"; 
   d="scan'208";a="17278091"
Message-ID: <4DFAA665.8070305@intel.com>
Date: Fri, 17 Jun 2011 08:57:09 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com> <20110614145246.GA17469@srcf.ucam.org> <4DF82CBC.5070400@intel.com> <20110615121703.GA8638@srcf.ucam.org> <4DF950EB.7050400@intel.com> <20110616013812.GA32494@srcf.ucam.org> <4DF962AE.60204@intel.com> <20110616015736.GA32533@srcf.ucam.org>
In-Reply-To: <20110616015736.GA32533@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 09:57 AM, Matthew Garrett wrote:
> On Thu, Jun 16, 2011 at 09:55:58AM +0800, Huang Ying wrote:
>> On 06/16/2011 09:38 AM, Matthew Garrett wrote:
>>> I think we probably need to make the HEST decision early, and use that 
>>> to decide how to make the generic call. Our experience has been that 
>>> many firmware vendors only expect _OSC to be called once with any given 
>>> UUID - multiple calls can result in unexpected behaviour.
>>
>> acpi_bus_osc_support is called via subsys_initcall.  It is a little hard
>> to do all checking before that.  Is it possible to call
>> acpi_bus_osc_support later?
> 
> Yeah, this is going to be a problem. We have the HEST available at this 
> point so we ought to be able to parse it, though. I'll take a look 
> tomorrow.

We can check the HEST table before _OSC evaluating.  But it is much
harder to check software part, because we have implemented GHES support
(Generic Hardware Error Source, the handler of firmware first mode
hardware error notification) as device driver and module.

So I think we can do that in 2 steps.  At first, we just enable WHEA
UUID, because that is easier to do.  Then we find a way to implement
"APEI bit" in generic _OSC call.  Do you think that is a good idea?

Best Regards,
Huang Ying
