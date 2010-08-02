Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0HBMW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:22:28 -0400
Received: from mail-forward1.uio.no ([129.240.10.70]:53307 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0HBMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:22:26 -0400
X-Greylist: delayed 1922 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2010 08:22:26 EDT
Message-ID: <4C56B018.8030309@simula.no>
Date: Mon, 02 Aug 2010 13:46:32 +0200
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100209 Shredder/3.0.2pre
MIME-Version: 1.0
To: Josh Hunt <johunt@akamai.com>
CC: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        juhlenko@akamai.com
Subject: Re: [PATCH] net: Add getsockopt support for TCP thin-streams
References: <1280533775-7700-1-git-send-email-johunt@akamai.com>
In-Reply-To: <1280533775-7700-1-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 8 sum msgs/h 1 total rcpts 267 max rcpts/h 55 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 87FB503D69BA1BBC843037389757B3A85DAD199A
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 11 total 16230 max/h 86 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2010 01:49 AM, Josh Hunt wrote:
> Initial TCP thin-stream commit did not add getsockopt support for the new
> socket options: TCP_THIN_LINEAR_TIMEOUTS and TCP_THIN_DUPACK. This adds support
> for them.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  net/ipv4/tcp.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 65afeae..3ed3525 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2591,6 +2591,12 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
>  			return -EFAULT;
>  		return 0;
>  	}
> +	case TCP_THIN_LINEAR_TIMEOUTS:
> +		val = tp->thin_lto;
> +		break;
> +	case TCP_THIN_DUPACK:
> +		val = tp->thin_dupack;
> +		break;
>  	default:
>  		return -ENOPROTOOPT;
>  	}

Thanks for noticing and fixing this :)

Tested-by: Andreas Petlund <apetlund@simula.no>
Acked-by: Andreas Petlund <apetlund@simula.no>

-Andreas
