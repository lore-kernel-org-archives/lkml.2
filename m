Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab0FQNrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 09:47:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58474 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760056Ab0FQNq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 09:46:59 -0400
Message-ID: <4C1A2735.304@zytor.com>
Date: Thu, 17 Jun 2010 06:46:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org> <4C19A2EE.2010203@zytor.com> <4C19AABA.8000706@jp.fujitsu.com> <4C19BA9A.4010300@zytor.com> <4C19EC57.3000409@goop.org>
In-Reply-To: <4C19EC57.3000409@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 02:35 AM, Jeremy Fitzhardinge wrote:
>>>
>>> By the way, is there linux kernel limit regarding above 44-bits physical
>>> address in x86_32 PAE? For example, pfn above 32-bits is not supported?
> 
> That's an awkward situation.  I would tend to suggest that you not
> support this type of machine with a 32-bit kernel.  Is it a sparse
> memory system, or is there a device mapped in that range?
> 
> I guess it would be possible to special-case ioremap to allow the
> creation of such mappings, but I don't know what kind of system-wide
> fallout would happen as a result.  The consequences of something trying
> to extract a pfn from one of those ptes would be
> 
>> There are probably places at which PFNs are held in 32-bit numbers,
>> although it would be good to track them down if it isn't too expensive
>> to fix them (i.e. doesn't affect generic code.)
>>   
> 
> There are many places which hold pfns in 32 bit variables on 32 bit
> systems; the standard type for pfns is "unsigned long", pretty much
> everywhere in the kernel.  It might be worth defining a pfn_t and
> converting usage over to that, but it would be a pervasive change.
> 

I think you're right, and just making 2^44 work correctly would be good
enough.  Doing special forwarding of all 52 bits of the real physical
address in the paravirt case (where it is self-contained and doesn't
spill into the rest of the kernel) would probably be a good thing, though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

