Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab2F0Vmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:42:47 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42565 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab2F0Vmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:42:45 -0400
Message-ID: <4FEB7E19.8040702@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2012 16:41:45 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Minchan Kim <minchan@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Konrad Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com> <4FEA9FDD.6030102@kernel.org> <4FEAA4AA.3000406@intel.com> <4FEAA7A1.9020307@kernel.org> <90bcc2c8-bcac-4620-b3c0-6b65f8d9174d@default> <4FEB5204.3090707@linux.vnet.ibm.com> <80ad7298-23de-4c5e-9a8d-483198ae4ef1@default>
In-Reply-To: <80ad7298-23de-4c5e-9a8d-483198ae4ef1@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062721-5518-0000-0000-000005944D0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 04:15 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> I guess I'm not following.  Are you supporting the removal
>> of the "break even" logic?  I added that logic as a
>> compromise for Peter's feedback:
>>
>> http://lkml.org/lkml/2012/5/17/177
> 
> Yes, as long as I am correct that zsmalloc never has to map/flush
> more than two pages at a time, I think dealing with the break-even
> logic is overkill.

The implementation of local_flush_tlb_kernel_range()
shouldn't be influenced by zsmalloc at all.  Additionally,
we can't assume that zsmalloc will always be the only user
of this function.

> I see Peter isn't on this dist list... maybe
> you should ask him if he agrees, as long as we are only always
> talking about flush-two-TLB-pages vs flush-all.

Yes, I'm planning to send out the next version of patches
tomorrow (minus the first that has already been accepted)
and I'll include him like I should have the first time :-/

> (And, of course, per previous discussion, I think even mapping/flushing
> two TLB pages is unnecessary and overkill required only for protecting an
> abstraction, but will stop beating that dead horse. ;-)

With this patchset, I actually quantified the the
performance gain with page table assisted mapping vs mapping
via copy, and there is a significant 40% difference in
single-threaded performance.

You can do the test yourself by commenting out the
#define __HAVE_ARCH_LOCAL_FLUSH_TLB_KERNEL_RANGE
in tlbflush.h which will cause the new mapping via copy
method to be used.

--
Seth

