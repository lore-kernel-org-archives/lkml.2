Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2LKS1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:27:25 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:53087 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab2LKS1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:27:24 -0500
Date: Tue, 11 Dec 2012 10:27:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: zram: fix invalid memory references during disk write
Message-ID: <20121211182720.GC29421@kroah.com>
References: <1354257909-2380-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354257909-2380-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:45:09PM -0800, Nitin Gupta wrote:
> Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
> of incompressible pages") which caused invalid memory references
> during disk write. Invalid references could occur in two cases:
>  - Incoming data expands on compression: In this case, reference was
> made to kunmap()'ed bio page.
>  - Partial (non PAGE_SIZE) write with incompressible data: In this
> case, reference was made to a kfree()'ed buffer.
> 
> Fixes bug 50081:
> https://bugzilla.kernel.org/show_bug.cgi?id=50081
> 
> Upstream commit ID: c8f2f0d: zram: Fix handling of incompressible pages
> Apply to versions: 3.6.5, 3.6.6, 3.6.7, 3.6.8
> 
> Cc: <stable@vger.kernel.org> # staging-next: 37b51fd: zram: factor-out
> 				# zram_decompress_page() function
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
> Reported-by: Tomas M <tomas@slax.org>
> Reviewed-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zram/zram_drv.c |   39 ++++++++++++++++++++++++---------------
>  1 file changed, 24 insertions(+), 15 deletions(-)

This patch fails to apply to 3.6.10:

patching file drivers/staging/zram/zram_drv.c
Hunk #1 succeeded at 282 (offset 17 lines).
Hunk #2 FAILED at 286.
Hunk #3 succeeded at 319 (offset 17 lines).
Hunk #4 succeeded at 340 (offset 17 lines).
Hunk #5 succeeded at 353 (offset 17 lines).
Hunk #6 succeeded at 368 (offset 17 lines).
Hunk #7 succeeded at 385 (offset 17 lines).
1 out of 7 hunks FAILED -- saving rejects to file drivers/staging/zram/zram_drv.c.rej

Please redo this patch and resend it if you wish for it to be applied to
the 3.6-stable tree.

thanks,

greg k-h
