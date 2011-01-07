Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1AGTLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:11:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:36745 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab1AGTLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:11:31 -0500
Date: Fri, 7 Jan 2011 14:10:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [069/152] econet: Do the correct cleanup after an
 unprivileged SIOCSIFADDR.
Message-ID: <20110107191036.GG32717@windriver.com>
References: <20110106002500.GA3172@kroah.com>
 <20110106002303.148373791@clark.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106002303.148373791@clark.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jan 2011 19:10:37.0777 (UTC) FILETIME=[91680410:01CBAE9E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[stable] [069/152] econet: Do the correct cleanup after an unprivileged SIOCSIFADDR.] On 05/01/2011 (Wed 16:22) Greg KH wrote:

> 2.6.36-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> 
> From: Nelson Elhage <nelhage@ksplice.com>
> 
> [ Upstream commit f24b8bedf70c524775eabd51570c3fa7708a97b7 ]

I think the upstream # got mangled somehow.  Looking at the tree, I
think the upstream is 0c62fc6dd02c8d793c75ae76a9b6881fc36388ad.

The ID listed currently gives me a "bad object". 

Thanks,
Paul.

> 
> We need to drop the mutex and do a dev_put, so set an error code and break like
> the other paths, instead of returning directly.
> 
> Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  net/econet/af_econet.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> --- a/net/econet/af_econet.c
> +++ b/net/econet/af_econet.c
> @@ -661,8 +661,10 @@ static int ec_dev_ioctl(struct socket *s
>  	err = 0;
>  	switch (cmd) {
>  	case SIOCSIFADDR:
> -		if (!capable(CAP_NET_ADMIN))
> -			return -EPERM;
> +		if (!capable(CAP_NET_ADMIN)) {
> +			err = -EPERM;
> +			break;
> +		}
>  
>  		edev = dev->ec_ptr;
>  		if (edev == NULL) {
> 
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
