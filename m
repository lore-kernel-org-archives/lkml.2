Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab2JRKNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:13:46 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38167 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab2JRKNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:13:44 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20121018094715.GC5685@mwanda>
References: <1350230064.4069.1.camel@lorien2> <20121018094715.GC5685@mwanda>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 18 Oct 2012 12:13:23 +0200
Message-ID: <CAKgNAkhx2trGUMCbpYbKbMYYjq9oTeAnqG436_MP2t6noA3K-g@mail.gmail.com>
Subject: Re: [PATCH] Documentation DMA-API-HOWTO.txt Add dma mapping error
 check usage examples
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Shuah Khan <shuah.khan@hp.com>, Andrew Morton <akpm@linux-foundation.org>,
        konrad.wilk@oracle.com, rob@landley.net, joerg.roedel@amd.com,
        shuahkhan@gmail.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:47 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Sun, Oct 14, 2012 at 09:54:24AM -0600, Shuah Khan wrote:
>> diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
>> index a0b6250..cf1adb4 100644
>> --- a/Documentation/DMA-API-HOWTO.txt
>> +++ b/Documentation/DMA-API-HOWTO.txt
>> @@ -468,11 +468,46 @@ To map a single region, you do:
>>       size_t size = buffer->len;
>>
>>       dma_handle = dma_map_single(dev, addr, size, direction);
>> +     if (unlikely(dma_mapping_error(dma_handle))) {
>
> Don't encourage people to put unlikely() and likely() into their
> driver code.  It should only be used after benchmarking both with
> and without.  I can't imagine how it would make a measurable
> difference here.

(Hi Dan)

Quite. See http://blog.man7.org/2012/10/how-much-do-builtinexpect-likely-and.html

I wonder how many blind uses of likely() and unlikely() in the kernel
are actually degrading performance.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
