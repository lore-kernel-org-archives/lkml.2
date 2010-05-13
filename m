Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab0EMUsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:48:38 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:50174 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab0EMUsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:48:36 -0400
X-Greylist: delayed 1135 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2010 16:48:36 EDT
Date: Thu, 13 May 2010 22:29:37 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Julia Lawall <julia@diku.dk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/20] drivers/net: Use kzalloc
Message-ID: <20100513202937.GA1795@mail.wantstofly.org>
References: <Pine.LNX.4.64.1005132200050.6282@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005132200050.6282@ask.diku.dk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:00:22PM +0200, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Use kzalloc rather than the combination of kmalloc and memset.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,size,flags;
> statement S;
> @@
> 
> -x = kmalloc(size,flags);
> +x = kzalloc(size,flags);
>  if (x == NULL) S
> -memset(x, 0, size);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
