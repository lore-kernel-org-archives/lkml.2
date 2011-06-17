Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab1FQBkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:40:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:60422 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab1FQBkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:40:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,378,1304319600"; 
   d="scan'208";a="19211163"
Message-ID: <4DFAB081.6050800@intel.com>
Date: Fri, 17 Jun 2011 09:40:17 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com> <20110614145246.GA17469@srcf.ucam.org> <4DF82CBC.5070400@intel.com> <20110615121703.GA8638@srcf.ucam.org> <4DF950EB.7050400@intel.com> <20110616013812.GA32494@srcf.ucam.org> <4DF962AE.60204@intel.com> <20110616015736.GA32533@srcf.ucam.org> <4DFAA665.8070305@intel.com> <20110617013442.GA30708@srcf.ucam.org>
In-Reply-To: <20110617013442.GA30708@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 09:34 AM, Matthew Garrett wrote:
> On Fri, Jun 17, 2011 at 08:57:09AM +0800, Huang Ying wrote:
>> On 06/16/2011 09:57 AM, Matthew Garrett wrote:
>>> Yeah, this is going to be a problem. We have the HEST available at this 
>>> point so we ought to be able to parse it, though. I'll take a look 
>>> tomorrow.
>>
>> We can check the HEST table before _OSC evaluating.  But it is much
>> harder to check software part, because we have implemented GHES support
>> (Generic Hardware Error Source, the handler of firmware first mode
>> hardware error notification) as device driver and module.
> 
> If the kernel has been configured with support for the feature then I 
> think we ought to be able to assume that the kernel will support it at 
> runtime.

There may be error during driver initialization.  That is what I am
concerned.

>> So I think we can do that in 2 steps.  At first, we just enable WHEA
>> UUID, because that is easier to do.  Then we find a way to implement
>> "APEI bit" in generic _OSC call.  Do you think that is a good idea?
> 
> I'm fine with that, providing that GHES isn't disabled purely because 
> the WHEA UUID call wasn't successful.

Because we have not added the code to make generic _OSC call with "APEI
bit" now, so if WHEA UUID call failed, we have no firmware first mode
enabled.  So I think it is safe to disable GHES if WHEA UUID call
failed.  But in another hand, keeping GHES has no harm too.  So I am OK
to keep GHES if WHEA UUID call failed.

Best Regards,
Huang Ying
