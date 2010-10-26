Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab0JZM2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:28:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:52940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478Ab0JZM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:28:39 -0400
Message-ID: <4CC6C941.2080003@kernel.org>
Date: Tue, 26 Oct 2010 14:27:45 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] MN10300: Fix the PERCPU() alignment to allow for workqueues
References: <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk> <12101.1288088542@redhat.com> <4CC6C62F.1000804@kernel.org>
In-Reply-To: <4CC6C62F.1000804@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 12:27:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 02:14 PM, Tejun Heo wrote:
>>> That said, I think it might be better to just remove the alignment parameter
>>> from the macro and force align to PAGE_SIZE.
>>
>> That's not necessarily good.  Two arches to note:
>>
>> 	arch/x86/kernel/vmlinux.lds.S:  PERCPU(THREAD_SIZE)
> 
> I don't think the current percpu allocator honors alignment larger
> than PAGE_SIZE no matter how large the alignment for the percpu output
> section is.  I'll look into it deeper but I think we might just have
> been lucky and the alignment somehow didn't bite us yet.  The only
> user of THREAD_SIZE mask at this point seems to be cpu_init().  Maybe
> we can remove this requirement.  I'll look into it.

Okay, this was added by commit fe8e0c2 in this merge window.  It's
broken and needs to be reverted.  I'll send a patch to revert it.

Thanks.

-- 
tejun
