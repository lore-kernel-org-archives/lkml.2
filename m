Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab0EYPVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:21:25 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35178 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab0EYPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rElvQZkdScdPvBFEfJK0XzOB6WgMKVfUTls8gpBhisYs34Tvl246V8JSooP5b38VX1
         aVbGZ0tNFaVNmTArwTj1+iJ93g6oXxXLfsx1Gi8RBaNYcPMHVFKCk3y+chyQQxGnWZHi
         gAEYdZZhr5xg871SBhB20Fz89xUjcjKbU8KSw=
Date: Wed, 26 May 2010 00:21:15 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] zram: generic RAM based compressed R/W block
 devices
Message-ID: <20100525152115.GB3227@barrios-desktop>
References: <1274710685-2351-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274710685-2351-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Nitin. 

On Mon, May 24, 2010 at 07:48:02PM +0530, Nitin Gupta wrote:
> Creates RAM based block devices: /dev/zramX (X = 0, 1, ...).
> Pages written to these disks are compressed and stored in memory
> itself. These disks allow very fast I/O and compression provides
> good amounts of memory savings.
> 
> This is enhancement over existing ramzswap driver which creates
> virtual block devices (/dev/ramzswapX) which could be used only
> as swap disks.
> 
> Now, with the ability to handle any kind of I/O request, zram
> devices have lot more use cases:
>  - /tmp storage
>  - various caches under /var
>  - swap disks
>  - maybe even more! :)

Wow, it looks good to me. 

As a matter of fact, when I saw your descriptoin, I thought we can merge 
your feature into brd. But I changed my mind due to following as 

First of all, ramfs supports direct I/O. So it's hard to support compression. 
If we can select optionable config, it would make brd code complicated or ugly.
That's because ramzswap uses own allocator, compression, extended ioctl and so on. 
And some users might regard write with important than read without considering space.
So it would be better to keep other block device for easy use and clear code. 

I will review this code when I have a time. 
Thanks, Nitin. 

-- 
Kind regards,
Minchan Kim
