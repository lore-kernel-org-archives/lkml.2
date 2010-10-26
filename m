Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab0JZO5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:57:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:58527 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab0JZO5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:57:15 -0400
Message-ID: <4CC6EC31.4090304@kernel.org>
Date: Tue, 26 Oct 2010 16:56:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] MN10300: Fix the PERCPU() alignment to allow for workqueues
References: <4CC6C62F.1000804@kernel.org> <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk> <12101.1288088542@redhat.com> <14874.1288104642@redhat.com>
In-Reply-To: <14874.1288104642@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 14:56:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On 10/26/2010 04:50 PM, David Howells wrote:
>>> FRV's page size is 16KB, so on that we really don't want it to be
>>> PAGE_SIZE.
>>
>> Why not?  It's in the init section which will be freed anyway and with
>> the kernel image compression it's not even gonna add any noticeable
>> amount to the kernel image size.  There isn't any benefit in using
>> anything smaller than PAGE_SIZE for alignment.  Also, percpu allocator
>> guarantees alignment requirement upto PAGE_SIZE is honored.  If the
>> output section uses smaller alignment, the percpu AS will end up being
>> misaligned.
> 
> The bootloader we have doesn't do decompression.

I see.  :-(

> On the other hand, does the PERCPU stuff need to be allocated space
> in the image by the linker?  Can it be initialised to anything other
> than zeros?

Sure, for example, in kernel/timer.c.

  static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;

It doesn't seem too popular at this point tho.

Thanks.

-- 
tejun
