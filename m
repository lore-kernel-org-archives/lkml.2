Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1FQBfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:35:02 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40964 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab1FQBe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:34:56 -0400
Date: Fri, 17 Jun 2011 02:34:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
Message-ID: <20110617013442.GA30708@srcf.ucam.org>
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com>
 <20110614145246.GA17469@srcf.ucam.org>
 <4DF82CBC.5070400@intel.com>
 <20110615121703.GA8638@srcf.ucam.org>
 <4DF950EB.7050400@intel.com>
 <20110616013812.GA32494@srcf.ucam.org>
 <4DF962AE.60204@intel.com>
 <20110616015736.GA32533@srcf.ucam.org>
 <4DFAA665.8070305@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFAA665.8070305@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 08:57:09AM +0800, Huang Ying wrote:
> On 06/16/2011 09:57 AM, Matthew Garrett wrote:
> > Yeah, this is going to be a problem. We have the HEST available at this 
> > point so we ought to be able to parse it, though. I'll take a look 
> > tomorrow.
> 
> We can check the HEST table before _OSC evaluating.  But it is much
> harder to check software part, because we have implemented GHES support
> (Generic Hardware Error Source, the handler of firmware first mode
> hardware error notification) as device driver and module.

If the kernel has been configured with support for the feature then I 
think we ought to be able to assume that the kernel will support it at 
runtime.

> So I think we can do that in 2 steps.  At first, we just enable WHEA
> UUID, because that is easier to do.  Then we find a way to implement
> "APEI bit" in generic _OSC call.  Do you think that is a good idea?

I'm fine with that, providing that GHES isn't disabled purely because 
the WHEA UUID call wasn't successful.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
