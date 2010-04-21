Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0DUWeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:34:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52181 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab0DUWeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:34:09 -0400
Message-ID: <4BCF7D38.8070206@zytor.com>
Date: Wed, 21 Apr 2010 15:33:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yinghai.lu@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andy Isaacson <adi@hexapodia.org>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 3/3] x86,pci,acpi: Handle invalid _CRS
References: <20100409223532.GC11130@hexapodia.org> <201004210921.50502.bjorn.helgaas@hp.com> <4BCF2BBA.4080708@oracle.com> <201004211059.17264.bjorn.helgaas@hp.com>
In-Reply-To: <201004211059.17264.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 09:59 AM, Bjorn Helgaas wrote:
> On Wednesday 21 April 2010 10:45:46 am Yinghai Lu wrote:
>> On 04/21/2010 08:21 AM, Bjorn Helgaas wrote:
> 
>>> Why are you doing this patch?  Did you see a machine where the host
>>> bridge was left with no resources because of _CRS issues?  If so,
>>> this patch feels like a band-aid.  I'd rather investigate the issue
>>> directly, because that would probably be a Linux problem we could fix.
>>>
>>> Also, if there *is* a reported problem, you should include a link to
>>> the bugzilla or email thread.
>>>   
>> No, just code review.
> 
> In that case, I don't think this patch is a good idea.  Assume we have
> a Linux problem with _CRS parsing, and as a result, we don't find any
> host bridge resources.  This patch will cause us to silently revert to
> the default resources, so we lose the opportunity to debug and fix the
> Linux problem.
> 
> Even worse, if there's a *BIOS* problem with _CRS, this patch will hide
> it and make it harder to diagnose.
> 
> Bjorn

Hi Bjorn,

Do you have opinions on patches 1-2 of the series?

I'm getting concerned about how the size of the patchset has grown, and
we're past -rc5 already... but it is a regression so we can't just defer
it to .35.

	-hpa
