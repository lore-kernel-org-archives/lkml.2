Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2JCEoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:44:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57500 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab2JCEon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:44:43 -0400
Message-ID: <506BC2A0.8060500@zytor.com>
Date: Tue, 02 Oct 2012 21:44:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: T Makphaibulchoke <tmac@hp.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, akpm@linux-foundation.org, yinghai@kernel.org,
        tiwai@suse.de, viro@zeniv.linux.org.uk, aarcange@redhat.com,
        tony.luck@intel.com, mgorman@suse.de, weiyang@linux.vnet.ibm.com,
        octavian.purdila@intel.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Fix devmem_is_allowed for below 1MB accesses for an efi
 machine
References: <1349213536-3436-1-git-send-email-tmac@hp.com> <506B6191.6080605@zytor.com> <20121003043116.GA26241@srcf.ucam.org>
In-Reply-To: <20121003043116.GA26241@srcf.ucam.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 09:31 PM, Matthew Garrett wrote:
> On Tue, Oct 02, 2012 at 02:50:09PM -0700, H. Peter Anvin wrote:
> 
>> That sounds like exactly the opposite of normal /dev/mem behavior... we
>> allow access to non-memory resources (which really could do anything if
>> misused), but not memory.
> 
> From arch/x86/mm/init.c:
> 
>  * On x86, access has to be given to the first megabyte of ram because that area
>  * contains bios code and data regions used by X and dosemu and similar apps.
> 
> Limiting this to just RAM would be safer than it currently is. I'm not 
> convinced that there's any good reason to allow *any* access down there 
> for EFI systems, though.
> 

Sorry, fail.

We *always* expose the I/O regions to /dev/mem.  That is what /dev/mem
*does*.  The above is an exception (which is really obsolete, too: we
should simply disallow access to anything which is treated as system
RAM, which doesn't include the BIOS regions in question; the only reason
we don't is that some versions of X take a checksum of the RAM in the
first megabyte as some kind of idiotic random seed.)

	-hpa
