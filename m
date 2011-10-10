Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1JJVKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:10:02 -0400
Received: from mail.vyatta.com ([76.74.103.46]:43960 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab1JJVKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:10:00 -0400
Date: Mon, 10 Oct 2011 14:09:57 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Muraliraja Muniraju <muralira@google.com>
Cc: "David S. Miller\"" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net-netlink: Add a new attribute to expose TOS
 values via netlink
Message-ID: <20111010140957.69f10b06@nehalam.linuxnetplumber.net>
In-Reply-To: <1318278745-27734-1-git-send-email-muralira@google.com>
References: <20111010130713.6df8bfe4@nehalam.linuxnetplumber.net>
	<1318278745-27734-1-git-send-email-muralira@google.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 13:32:25 -0700
Muraliraja Muniraju <muralira@google.com> wrote:

> From: Murali Raja <muralira@google.com>
> 
> This patch exposes the tos value for the TCP sockets when the TOS flag
> is requested in the ext_flags for the inet_diag request. This would mainly be
> used to expose TOS values for both for TCP and UDP sockets. Currently it is
> supported for TCP. When netlink support for UDP would be added the support
> to expose the TOS values would alse be done.
> 
> Signed-off-by: Murali Raja <muralira@google.com>
> ---
> Changelog since v1:
> - Removing the reserved field.
> 
>  include/linux/inet_diag.h |    9 ++++++++-
>  net/ipv4/inet_diag.c      |    7 +++++++
>  2 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
> index bc8c490..e36093d 100644
> --- a/include/linux/inet_diag.h
> +++ b/include/linux/inet_diag.h
> @@ -97,9 +97,10 @@ enum {
>  	INET_DIAG_INFO,
>  	INET_DIAG_VEGASINFO,
>  	INET_DIAG_CONG,
> +	INET_DIAG_TOS,
>  };
>  
> -#define INET_DIAG_MAX INET_DIAG_CONG
> +#define INET_DIAG_MAX INET_DIAG_TOS
>  
>  
>  /* INET_DIAG_MEM */
> @@ -120,6 +121,12 @@ struct tcpvegas_info {
>  	__u32	tcpv_minrtt;
>  };
>  
> +/* INET_DIAG_TOS */
> +
> +struct inet_diag_tos {
> +	__u8	idiag_tos;
> +};

I think the idea is a good one, and useful, but want to make the
ABI right.
With only one entry, this doesn't need to be wrapped in a structure.

Also does this work for IPv6 (Transport class) as well?

