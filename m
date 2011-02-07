Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1BGOdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:33:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab1BGOdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:33:53 -0500
Date: Mon, 7 Feb 2011 09:33:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Simon Horman <horms@verge.net.au>
Cc: Rob Landley <rlandley@parallels.com>, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Haren Myneni <hbabu@us.ibm.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Eric Biederman <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -next] Documentation: Improve crashkernel= description
Message-ID: <20110207143346.GB7437@redhat.com>
References: <20110206154108.GA16542@laptop>
 <20110206215733.GB26233@verge.net.au>
 <4D4F5810.3070300@parallels.com>
 <20110207024238.GA22477@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207024238.GA22477@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 11:42:38AM +0900, Simon Horman wrote:
> On Sun, Feb 06, 2011 at 08:25:20PM -0600, Rob Landley wrote:
> > On 02/06/2011 03:57 PM, Simon Horman wrote:
> > > On Sun, Feb 06, 2011 at 05:41:08PM +0200, Ahmed S. Darwish wrote:
> > >> (Also applicable over 2.6.38-rc3)
> > >>
> > >> Had to explore two C code files to make sense of the 'crashkernel='
> > >> kernel parameter values.  Improve the situation.
> > >>
> > >> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> > >> ---
> > >>
> > >> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > >> index 89835a4..8f26b42 100644
> > >> --- a/Documentation/kernel-parameters.txt
> > >> +++ b/Documentation/kernel-parameters.txt
> > >> @@ -545,9 +545,12 @@ and is between 256 and 4096 characters. It is defined in the file
> > >>  			Format:
> > >>  			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
> > >>  
> > >> -	crashkernel=nn[KMG]@ss[KMG]
> > >> -			[KNL] Reserve a chunk of physical memory to
> > >> -			hold a kernel to switch to with kexec on panic.
> > >> +	crashkernel=size[KMG][@offset[KMG]]
> > >> +			[KNL] Using kexec, Linux can switch to a 'crash kernel'
> > >> +			upon panic. This parameter reserves the physical
> > >> +			memory region [offset, offset + size] for that kernel
> > >> +			image. If the '@offset' part was ignored, Linux finds
> > >> +			a suitable crash image start address automatically.
> > > 
> > > I think this would be further improved as:
> > > 
> > > 			... If '@offset' is omitted then a suitable
> > > 			offset is selected automatically.
> > 
> > Suitable offset as in parses a known image type (ELF, bzImage, etc) to
> > find the start address?  Or just assumes the entry point and load
> > address are the same?
> 
> As in it finds a large enough area of contiguous free memory.
> I believe that originally it searched from the bottom of memory,
> it may be slightly smarter now.

Now it has been changed to search from top of the memory (atleast for x86) and
that caused few troubles. On 32bit it searches for memory under 512MB and
on x86_64, it searches for memory under 896MB.

Though hpa had suggested to enhance the command line syntax such that a
user specifies the upper bound on memory. Something like crashkernel=x < y.
So reserve X amount of memory below y MB. It boils down to same thing
that somebody has to know that what is the maximum physical memory
locaton kernel can boot from.

I think it is dependent on kernel as well as dependent on kexec-tools. I
am wondering if it is possible to make this info part of bzImage protocol
where kernel tells bootloader the maximum physical memory kernel can be
loaded at. I think this is off topic in the context of this patch, just
a thought...

Thanks
Vivek
