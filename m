Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0LWOnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:43:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60854 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0LWOm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=somrScE5C1rKpX9j65FFZv1sG7ulO/x+hGqANF/YQWhX41ksB9ZmJ4wnTzJaobMZgh
         DuDJWFciSYAu/9JYBr0SZeaXbyqaExPqze4zHOT9rcCI8gTq9Y8mQsHiSi2KM3WWizdF
         ViBpt8SQYBfcOH/vL+3mODU6/jX6fp78mMcdI=
MIME-Version: 1.0
In-Reply-To: <20101223141608.GM3636@n2100.arm.linux.org.uk>
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
	<AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
	<20101223100642.GD3636@n2100.arm.linux.org.uk>
	<00ea01cba290$4d67f500$e837df00$%szyprowski@samsung.com>
	<20101223121917.GG3636@n2100.arm.linux.org.uk>
	<4D135004.3070904@samsung.com>
	<20101223134838.GK3636@n2100.arm.linux.org.uk>
	<4D1356D7.2000008@samsung.com>
	<20101223141608.GM3636@n2100.arm.linux.org.uk>
Date: Thu, 23 Dec 2010 16:42:57 +0200
Message-ID: <AANLkTinzsOom5awOr6Y8e7PKRbCWYQOqEbdw9is6HroR@mail.gmail.com>
Subject: Re: [PATCHv8 00/12] Contiguous Memory Allocator
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tomasz Fujak <t.fujak@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kyungmin Park <kmpark@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Ankita Garg <ankita@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 4:16 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Dec 23, 2010 at 03:04:07PM +0100, Tomasz Fujak wrote:
>> In other words, should we take your response as yet another NAK?
>> Or would you try harder and at least point us to some direction that
>> would not doom the effort from the very beginning.
>
> What the fsck do you think I've been doing?  This is NOT THE FIRST time
> I've raised this issue.  I gave up raising it after the first couple
> of attempts because I wasn't being listened to.
>
> You say about _me_ not being very helpful.  How about the CMA proponents
> start taking the issue I've raised seriously, and try to work out how
> to solve it?  And how about blaming them for the months of wasted time
> on this issue _because_ _they_ have chosen to ignore it?

I've also raised the issue for ARM. However, I don't see what is the
big problem.

A generic solution (that I think I already proposed) would be to
reserve a chunk of memory for the CMA that can be removed from the
normally mapped kernel memory through memblock at boot time. The size
of this memory region would be configurable through kconfig. Then, the
CMA would have a "dma" flag or something, and take chunks out of it
until there's no more, and then return errors. That would work for
ARM.

Cheers.

-- 
Felipe Contreras
