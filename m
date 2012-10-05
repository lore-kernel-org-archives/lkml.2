Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2JEQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:28:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36531 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab2JEQ2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:28:11 -0400
Message-ID: <506F0A90.7020106@zytor.com>
Date: Fri, 05 Oct 2012 09:28:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: matt@console-pimps.org, matt.fleming@intel.com, mingo@kernel.org,
        x86@kernel.org, mjg@redhat.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map in
 trampoline_pgd
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org> <1349269157-25956-2-git-send-email-matt@console-pimps.org> <506C4C3A020000780008D041@nat28.tlf.novell.com> <506DFAD8.5060701@zytor.com> <506E9CDC020000780009FD13@nat28.tlf.novell.com>
In-Reply-To: <506E9CDC020000780009FD13@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 11:39 PM, Jan Beulich wrote:
>>
>> We should have the check, but at least for Linux support we require
>> P <= V-2.
>
> Not really imo - P <= V - 1 should be sufficient here, as all that is
> necessary is that the result represents a 1:1 mapping. Specifically,
> there's no constraint to the virtual space limitation of the direct
> mapping of RAM.
>

The P <= V-2 limitation doesn't come from this, it comes from the fact 
that we need to have the regular kernel 1:1 map and still have space for 
the kernel, vmalloc, ioremap and so on in the kernel part of the address 
space; in theory it *could* be some fraction between 1 and 2, but since 
hardware doesn't do fractional bits very well the above is what we have 
been telling the hardware folks. :)

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

