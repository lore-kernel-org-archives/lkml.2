Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0GHJxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 05:53:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19385 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852Ab0GHJxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 05:53:41 -0400
Date: Thu, 8 Jul 2010 02:51:56 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/3] ocfs2: When zero extending, do it by page.
Message-ID: <20100708095156.GB23392@mail.oracle.com>
Mail-Followup-To: Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
References: <20100703213219.GB21262@mail.oracle.com>
 <1278501367-7710-2-git-send-email-joel.becker@oracle.com>
 <4C3549BB.2000906@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3549BB.2000906@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C359FF8.0100:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 11:44:59AM +0800, Tao Ma wrote:
> On 07/07/2010 07:16 PM, Joel Becker wrote:
> >+	BUG_ON(abs_to>  ((index + 1)<<  PAGE_CACHE_SHIFT));
> Sorry for not noticing this yesterday night. This can't work and
> will overflow and bug out. I met with a similar bug in reflink test.
> See commit d622b89.

	Good catch.  It's obvious, now that you mention it.

> >+	/* We know that zero_from is block aligned */
> >+	for (block_start = zero_from;
> >+	     (block_start<  PAGE_CACHE_SIZE)&&  (block_start<  zero_to);
> >+	     block_start = block_end) {
> Do we really need to check block_start < PAGE_CACHE_SIZE? I think
> just check block_start < zero_to is enough since you have limit
> zero_to with PAGE_CACHE_SIZE. What's more, it looks more natural(see
> below), does it?
> 
> 	for (block_start = zero_form; block_start < zero_to; block_start =
> block_end) {

	Yup.  The code looked different halfway through, so I didn't
realize I was checking the same thing twice.

Joel

-- 

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
