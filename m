Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1CNWgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:36:51 -0400
Received: from fieldses.org ([174.143.236.118]:40512 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab1CNWgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:36:49 -0400
Date: Mon, 14 Mar 2011 18:36:45 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: roel <roel.kluin@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: svc_register error overwritten in next
 iteration
Message-ID: <20110314223645.GL25442@fieldses.org>
References: <4D7B74C7.7060506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7B74C7.7060506@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 02:27:35PM +0100, roel wrote:
> The break is in the inner loop, the svc_register() error is overwritten
> in the next iteration. Only the error in the last iteration is returned.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  net/sunrpc/svc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> Is this needed?
> 
> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index 08e05a8..5fd08c0 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -889,6 +889,8 @@ int svc_register(const struct svc_serv *serv, const int family,
>  			if (error < 0)
>  				break;

May as well just "goto out" or "return error" here?

But: aren't we missing some cleanup?  If we succesfully register one
program then fail at a second one, don't we need to unregister the
first?

--b.

>  		}
> +		if (error < 0)
> +			break;
>  	}
>  
>  	return error;
