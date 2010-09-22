Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0IVUZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:25:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37512 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0IVUZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:25:51 -0400
Message-ID: <4C9A6534.3060800@zytor.com>
Date: Wed, 22 Sep 2010 13:21:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Venkatesh Pallipadi <venki@google.com>,
        Prarit Bhargava <prarit@redhat.com>, Simon Arlott <simon@fire.lp0.eu>,
        x86@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org, Marc Jones <marcj303@gmail.com>,
        Jordan Crouse <jcrouse@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, HPET: ignore any PCI BARs that match an HPET we
 already know about
References: <20100922201547.3197.33702.stgit@bob.kio> <201009221419.47283.bjorn.helgaas@hp.com>
In-Reply-To: <201009221419.47283.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 01:19 PM, Bjorn Helgaas wrote:
> On Wednesday, September 22, 2010 02:15:47 pm Bjorn Helgaas wrote:
>>
>> We often discover the HPET early, via the static ACPI HPET table, before
>> enumerating PCI devices.  If the HPET is implemented as a PCI function,
>> we will discover it again during PCI device enumeration.  We must ignore
>> the PCI function so we don't inadvertently move it out from under the
>> driver.
>>
>> I think it's better to ignore *any* PCI BAR that matches a previously
>> discovered HPET; that way we don't need platform-specific knowledge,
>> and we won't have to add more quirks for future machines.
>>
>> This is for a regression from 2.6.34, but the reporter has been
>> unable to test it yet.
>>
>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=18482
> 
> I've tried hard to find somebody who can test this, but nobody who
> can reproduce the original failure has been able to test it.  I
> propose that we put it in linux-next and see what happens there.
> 

Makes sense to me.

	-hpa

