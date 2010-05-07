Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0EGUiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:38:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39930 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab0EGUiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:38:01 -0400
Message-ID: <4BE479EA.3080005@zytor.com>
Date: Fri, 07 May 2010 13:36:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Feng Tang <feng.tang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan.van.de.ven@intel.com>
Subject: Re: RFD: Should we remove the HLT check?  (was Re: [PATCH 1/8] x86:
 avoid check hlt if no timer interrupts)
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com> <4BE478C1.2060602@zytor.com> <4BE4791B.1060304@linux.intel.com>
In-Reply-To: <4BE4791B.1060304@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2010 01:33 PM, Arjan van de Ven wrote:
> On 5/7/2010 13:32, H. Peter Anvin wrote:
>>
>> I really wish I knew the exact systems affected by the HLT bug.  If I
>> remember correctly, it was some 386 systems -- or possibly 486 systems
>> as well -- a very long time ago.  This test just provides a diagnosis if
>> the system really is bad (it hangs with an obvious message) at the cost
>> of some 40 ms to the system boot time.  I suspect C1 (HLT) being broken
>> is not anywhere close to the predominant power management problem in the
>> current day, and as such I'm wondering if this particular test hasn't
>> outlived its usefulness.
>>
>> Thoughts?
> 
> we could at least hide it behind the "don't run on pentium or newer" config options..

I'd be cool skipping it for family 5 or newer.  I'm just wondering if we
should kill it completely -- IIRC it was only a handful of 386/486
systems which had problems, usually due to marginal power supplies which
couldn't handle the noise of a variable load (DOS not having any power
management would run at a reliable 100% load) -- that's not exactly the
type of systems which would have survived to modern day.

	-hpa

