Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2JCF1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 01:27:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58293 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab2JCF1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 01:27:47 -0400
Message-ID: <506BCCAE.5030203@zytor.com>
Date: Tue, 02 Oct 2012 22:27:10 -0700
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
References: <1349213536-3436-1-git-send-email-tmac@hp.com> <506B6191.6080605@zytor.com> <20121003043116.GA26241@srcf.ucam.org> <506BC2A0.8060500@zytor.com> <20121003051522.GA27113@srcf.ucam.org>
In-Reply-To: <20121003051522.GA27113@srcf.ucam.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 10:15 PM, Matthew Garrett wrote:
> On Tue, Oct 02, 2012 at 09:44:16PM -0700, H. Peter Anvin wrote:
> 
>> We *always* expose the I/O regions to /dev/mem.  That is what /dev/mem
>> *does*.  The above is an exception (which is really obsolete, too: we
>> should simply disallow access to anything which is treated as system
>> RAM, which doesn't include the BIOS regions in question; the only reason
>> we don't is that some versions of X take a checksum of the RAM in the
>> first megabyte as some kind of idiotic random seed.)
> 
> Oh, right, got you. In that case I think we potentially need a 
> finer-grained check on EFI platforms - the EFI memory map is kind enough 
> to tell us the difference between unusable regions and io regions, and 
> we could avoid access to the unusable ones.
> 

Well, we have the same in BIOS space with "reserved" regions.  The
problem is that they are actually I/O regions as far as programs like X,
dmidecode and so on.

	-hpa


