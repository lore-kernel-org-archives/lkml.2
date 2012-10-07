Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2JGK1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 06:27:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32789 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2JGK1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 06:27:44 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <50714881020000780008D43E@nat28.tlf.novell.com>
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org> <1349269157-25956-2-git-send-email-matt@console-pimps.org> <506C4C3A020000780008D041@nat28.tlf.novell.com> <506DFAD8.5060701@zytor.com> <506E9CDC020000780009FD13@nat28.tlf.novell.com> <506F0A90.7020106@zytor.com> <50714881020000780008D43E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map in trampoline_pgd
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 07 Oct 2012 19:26:57 +0900
To: Jan Beulich <jbeulich@suse.com>
CC: matt@console-pimps.org, matt.fleming@intel.com, mingo@kernel.org,
        x86@kernel.org, mjg@redhat.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <e0004a11-4caa-4100-8876-1e7346f50673@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, no, because we may need to double-map in the low address space per discussion at LPC.

Jan Beulich <jbeulich@suse.com> wrote:

>>>> "H. Peter Anvin" <hpa@zytor.com> 10/05/12 6:28 PM >>>
>>On 10/04/2012 11:39 PM, Jan Beulich wrote:
>>>>
>>>> We should have the check, but at least for Linux support we require
>>>> P <= V-2.
>>>
>>> Not really imo - P <= V - 1 should be sufficient here, as all that
>is
>>> necessary is that the result represents a 1:1 mapping. Specifically,
>>> there's no constraint to the virtual space limitation of the direct
>>> mapping of RAM.
>>>
>>
>>The P <= V-2 limitation doesn't come from this, it comes from the fact
>
>>that we need to have the regular kernel 1:1 map and still have space
>for 
>>the kernel, vmalloc, ioremap and so on in the kernel part of the
>address 
>>space; in theory it *could* be some fraction between 1 and 2, but
>since 
>>hardware doesn't do fractional bits very well the above is what we
>have 
>>been telling the hardware folks. :)
>
>I understand all that, but here we're talking about a true 1:1 mapping
>(i.e. in the lower half of the virtual address space), as opposed to
>the
>direct mapping (in the upper half). We can obviously use all of the
>lower
>half for this purpose.
>
>Jan

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
