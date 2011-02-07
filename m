Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1BGO0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:26:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab1BGO0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:26:15 -0500
Date: Mon, 7 Feb 2011 09:25:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Simon Horman <horms@verge.net.au>,
        Haren Myneni <hbabu@us.ibm.com>,
        Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 -next] Documentation: Improve crashkernel= description
Message-ID: <20110207142550.GA7437@redhat.com>
References: <20110206154108.GA16542@laptop>
 <20110206215733.GB26233@verge.net.au>
 <20110206201448.4a259575.rdunlap@xenotime.net>
 <20110207113054.GA10388@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207113054.GA10388@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 01:30:54PM +0200, Ahmed S. Darwish wrote:
> 
> Had to explore two C code files to make sense of the 'crashkernel='
> kernel parameter values.  Improve the situation.
> 

Did you look at Documentation/kdump/kdump.txt before looking into the
code. I thought kdump.txt explained the meaning of crashkernel= well.

In case if it was not obivious that for further details look into
kdump.txt, I will suggest to add a line asking reader to look into
kdump.txt for more details.

Tough crashkernel= range1:size1[,range2:size2,...][@offset], description
in next line already mentions kdump.txt

This patch looks good to me as it is though.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 89835a4..5ad9980 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -545,9 +545,12 @@ and is between 256 and 4096 characters. It is defined in the file
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
> +			is selected automatically.
>  
>  	crashkernel=range1:size1[,range2:size2,...][@offset]
>  			[KNL] Same as above, but depends on the memory
> 
> -- 
> Darwish
> http://darwish.07.googlepages.com
