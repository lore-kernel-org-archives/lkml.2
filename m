Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2KSHIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 02:08:15 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38723 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab2KSHIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 02:08:14 -0500
Date: Mon, 19 Nov 2012 15:08:04 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>, T Makphaibulchoke <tmac@hp.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 33/58] kernel/resource.c: Make internal function
 reallocate_resource static
Message-ID: <20121119070804.GA2427@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
 <1353302917-13995-34-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1353302917-13995-34-git-send-email-josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111907-5112-0000-0000-00000EB75589
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 09:28:12PM -0800, Josh Triplett wrote:
> Nothing outside of kernel/resource.c references reallocate_resource, so
> mark it static.  This eliminates warnings from GCC
> (-Wmissing-prototypes) and Sparse (-Wdecl).
> 
> kernel/resource.c:476:5: warning: no previous prototype for ‘reallocate_resource’ [-Wmissing-prototypes]
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  kernel/resource.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index f593f18..0cc07d4 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -473,7 +473,7 @@ static int find_resource(struct resource *root, struct resource *new,
>   * @newsize: new size of the resource descriptor
>   * @constraint: the size and alignment constraints to be met.
>   */
> -int reallocate_resource(struct resource *root, struct resource *old,
> +static int reallocate_resource(struct resource *root, struct resource *old,
>  			resource_size_t newsize,
>  			struct resource_constraint  *constraint)
>  {

Acked-by: Ram Pai <linuxram@us.ibm.com>

