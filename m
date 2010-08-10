Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab0HJX4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 19:56:02 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:57933 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854Ab0HJX4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 19:56:00 -0400
X-ASG-Debug-ID: 1281484558-285a000b0000-xx1T2L
X-Barracuda-URL: http://10.101.1.181:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C61E719.1050300@fusionio.com>
Date: Tue, 10 Aug 2010 19:56:09 -0400
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>
X-ASG-Orig-Subj: Re: [PATCH] lib/scatterlist: Hook sg_kmalloc into kmemleak (v2)
Subject: Re: [PATCH] lib/scatterlist: Hook sg_kmalloc into kmemleak (v2)
References: <1280220298-9641-1-git-send-email-chris@chris-wilson.co.uk> <1281477672.8973.20.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1281477672.8973.20.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1281484558
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 06:01 PM, Catalin Marinas wrote:
> Jens,
> 
> On Tue, 2010-07-27 at 09:44 +0100, Chris Wilson wrote:
>> kmemleak ignores page_alloc() and so believes the final sub-page
>> allocation using the plain kmalloc is decoupled and lost. This leads to
>> lots of false-positives with code that uses scatterlists.
>>
>> The options seem to be either to tell kmemleak that the kmalloc is not
>> leaked or to notify kmemleak of the page allocations. The danger of the
>> first approach is that we may hide a real leak, so choose the latter
>> approach (of which I am not sure of the downsides).
>>
>> v2: Added comments on the suggestion of Catalin.
>>
>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Jens Axboe <jaxboe@fusionio.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
> 
> Since you are the author of lib/scatterlist.c would you (or Tejun) mind
> ack'ing this patch? Thanks.

Looks completely straight forward.

Acked-by: Jens Axboe <jaxboe@fusionio.com>

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
