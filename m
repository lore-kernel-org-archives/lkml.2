Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab2EYQb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:31:56 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:25924 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab2EYQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:31:54 -0400
Message-ID: <4FBFB3F3.1000606@hp.com>
Date: Fri, 25 May 2012 10:31:47 -0600
From: Thavatchai Makphaibulcboke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Lasse Collin <lasse.collin@tukaani.org>
CC: "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kaloz@openwrt.org" <kaloz@openwrt.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>
Subject: Re: [PATCH] lib/decompress_unxz.c: removing all memory helper functions
References: <1337875436-27640-1-git-send-email-tmac@hp.com> <20120525113432.3beea6ed@tukaani.org>
In-Reply-To: <20120525113432.3beea6ed@tukaani.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 02:34 AM, Lasse Collin wrote:
> On 2012-05-24 T Makphaibulchoke wrote:
>> The patch cleans up the file lib/decompress_unxz.c by removing all
>> memory helper functions, e.g., memmove.  By doing so, any
>> architecture's preboot environment supporting the XZ decompression
>> needs to define its own copy of any of the missing memory helper
>> functions.
> 
> Is it best to copy these functions to each arch, or would it be better
> to have a shared file from which these functions could be pulled for
> multiple archs? I wasn't sure when I wrote decompress_unxz.c, which is
> why I put the extra functions there as a temporary solution.
> 

Yes, I agree that having a shared file would be the best solution.
Unfortunately with the current preboot architecture and infra structure,
it would not be a trivial task. I believe defining these functions for
each arch would give a better code modularity compared to including them
in the decompressor file.

>> Adding both the missing memmove and memcmp functions, required by the
>> XZ decompressor, to the sh preboot environment.
>>
>> Adding the missing memmove function, required by XZ decompressor, to
>> the x86 preboot environment.
> 
> These already have memcpy. It can save a few bytes if one reused
> memmove as memcpy when using XZ compression. I got a difference of 48
> bytes on x86_64.
> 

We could do that.  But according to the comment in the original
implementation, there seems to be a concern regarding its performance
speed. If you believe all archs' memcpy would give comparable
performance to the memmove. then I could do that.

> Adding memmove to string.c on x86 means that memmove is included in the
> kernel image even when memmove isn't needed. With gzip compression I
> got 128 bytes bigger image on x86_64 after adding the unneeded memmove
> to string.c.
> 
> I don't know if those size increases matter in practice.
> 
>> + * To support XZ-decompressed file in preboot environment, the
> 
> s/XZ-decompressed/XZ-compressed/ :-)
> 

For x86, I think I could move memmove to the misc.c file and put an
ifdef XZ_PREBOOT around it.  This way it should not impact other
decompressor.  I could also do this for s390 and sh.  But if we decide
to replace memmove with memcpy this would be necessart.

Thank you very for your comment.  Please let me know what you think.
I'll redo and send out a new patch.  Thanks in advance.

Thanks,
Mak.


