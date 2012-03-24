Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2CXEna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 00:43:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59654 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab2CXEn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 00:43:29 -0400
Message-ID: <4F6D50DD.4050306@zytor.com>
Date: Fri, 23 Mar 2012 21:43:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via
 initrd
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203240242.07724.trenn@suse.de> <4F6D2AF8.3070707@zytor.com> <201203240402.38749.trenn@suse.de>
In-Reply-To: <201203240402.38749.trenn@suse.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 08:02 PM, Thomas Renninger wrote:
>>
>> Sorry, it doesn't work that way.
> I guess this would not be the first time a good feature has been added,
> knowing that a more general API will be build around it later.
> 10 lines are really easy to adopt.
> 

No, what you want is to add a new interface, which is going to have to
be maintained indefinitely.  That's the problem.

>> I see two realistic options:
>>
>> 1. We use cpio encapsulation for everything, with a special namespace
>>    for items used directly by the kernel, e.g. "kernel/".
>>
>>    + Simple, existing tools can pick apart
>>    - May lead people to believe that the early-initrd portion can be
>>      compressed like the "normal" initrd portion, leading to strange
>>      problems.
> Can this be implemented without using dynamic memory allocations?
> If not, it's not suitable for early APCI overriding.

Yes it can, as long as it is uncompressed.  It just becomes a matter of
walking the cpio headers which is effectively a linked list.

It is more code than the simple header option, though.

By the way, if "relying on the bootloader" was an option in any way then
we would already have a solution in the form of the kernel data linked
list.  Unfortunately to the best of my knowledge not a single bootloader
provides support for it.

	-hpa
