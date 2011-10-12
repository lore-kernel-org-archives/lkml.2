Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab1JLCtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 22:49:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41008 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1JLCtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 22:49:02 -0400
Message-ID: <1318387734.3686.2.camel@edumazet-laptop>
Subject: Re: [PATCH v3] net-netlink: Add a new attribute to expose TOS
 values via netlink
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Muraliraja Muniraju <muralira@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 12 Oct 2011 04:48:54 +0200
In-Reply-To: <1318382887-31824-1-git-send-email-muralira@google.com>
References: <20111010145206.6f7e9ee2@nehalam.linuxnetplumber.net>
	 <1318382887-31824-1-git-send-email-muralira@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 11 octobre 2011 à 18:28 -0700, Muraliraja Muniraju a écrit :
> From: Murali Raja <muralira@google.com>
> 
> This patch exposes the tos value for the TCP sockets when the TOS flag
> is requested in the ext_flags for the inet_diag request. This would mainly be
> used to expose TOS values for both for TCP and UDP sockets. Currently it is
> supported for TCP. When netlink support for UDP would be added the support
> to expose the TOS values would alse be done.
> 

You could mention TCLASS support for IPv6

> Signed-off-by: Murali Raja <muralira@google.com>
> ---
> Changelog since v2:
> - Adding support for IPV6 class and using right API's
> Changelog since v1:
> - Removing reserved field 
> 
>  include/linux/inet_diag.h |    9 ++++++++-
>  net/ipv4/inet_diag.c      |    5 +++++
>  2 files changed, 13 insertions(+), 1 deletions(-)
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

Are you sure its still needed ?

I am now wondering what is done in TIME_WAIT state.


