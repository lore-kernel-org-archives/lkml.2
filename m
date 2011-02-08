Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1BHSvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:51:05 -0500
Received: from xenotime.net ([72.52.115.56]:55858 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755413Ab1BHSvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:51:03 -0500
Date: Tue, 8 Feb 2011 10:50:58 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Simon Horman <horms@verge.net.au>,
        Haren Myneni <hbabu@us.ibm.com>,
        Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 -next] Documentation: Improve crashkernel=
 description
Message-Id: <20110208105058.0cc7da2d.rdunlap@xenotime.net>
In-Reply-To: <20110207160127.GA25828@laptop>
References: <20110206154108.GA16542@laptop>
	<20110206215733.GB26233@verge.net.au>
	<20110206201448.4a259575.rdunlap@xenotime.net>
	<20110207113054.GA10388@laptop>
	<20110207142550.GA7437@redhat.com>
	<20110207160127.GA25828@laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011 18:01:27 +0200 Ahmed S. Darwish wrote:

> On Mon, Feb 07, 2011 at 09:25:50AM -0500, Vivek Goyal wrote:
> > On Mon, Feb 07, 2011 at 01:30:54PM +0200, Ahmed S. Darwish wrote:
> > > 
> > > Had to explore two C code files to make sense of the 'crashkernel='
> > > kernel parameter values.  Improve the situation.
> > > 
> > 
> > Did you look at Documentation/kdump/kdump.txt before looking into the
> > code. I thought kdump.txt explained the meaning of crashkernel= well.
> > 
> > In case if it was not obivious that for further details look into
> > kdump.txt, I will suggest to add a line asking reader to look into
> > kdump.txt for more details.
> > 
> 
> Yes, I jumped to the code first :-) Here's a new patch with the link:
> 
> (Also applicable over latest -rc3)
> 
> ==>
> 
> Complete the crashkernel= kernel parameter documentation.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 89835a4..050b0e5 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -545,16 +545,20 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Format:
>  			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
>  
> -	crashkernel=nn[KMG]@ss[KMG]
> -			[KNL] Reserve a chunk of physical memory to
> -			hold a kernel to switch to with kexec on panic.
> +	crashkernel=size[KMG][@offset[KMG]]
> +			[KNL] Using kexec, Linux can switch to a 'crash kernel'
> +			upon panic. This parameter reserves the physical
> +			memory region [offset, offset + size] for that kernel
> +			image. If '@offset' is omitted, then a suitable offset
> +			is selected automatically. Check
> +			Documentation/kdump/kdump.txt for further details.
>  
>  	crashkernel=range1:size1[,range2:size2,...][@offset]
>  			[KNL] Same as above, but depends on the memory
>  			in the running system. The syntax of range is
>  			start-[end] where start and end are both
>  			a memory unit (amount[KMG]). See also
> -			Documentation/kdump/kdump.txt for a example.
> +			Documentation/kdump/kdump.txt for an example.
>  
>  	cs89x0_dma=	[HW,NET]
>  			Format: <dma>
> 
> 
> > 
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>


Applied v3, along with your KMG info patch.  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
