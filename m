Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0LIRMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:12:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53817 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab0LIRMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RH832UKb/2GjgqnwZG15Kk+YFF41B3FscpjreeWplVnQU/TYnd/3mSuCRmwzqpy2Uc
         S4mmar/xSYm1zMuq4cRCMsl1DKgj0askzONcoIkmSDSNVqj7/TDUvQ2sU9z0qtEqItxV
         /Zb+yjsnMplNLmMISLa9yE6y7HF/TeTTyowNY=
Subject: Re: [PATCH] Document the kernel_recvmsg() function
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Martin Lucina <mato@kotelna.sk>
Cc: linux-kernel@vger.kernel.org, Martin Sustrik <sustrik@250bpm.com>
In-Reply-To: <20101209161734.GA16822@dezo.moloch.sk>
References: <20101209161734.GA16822@dezo.moloch.sk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 18:12:12 +0100
Message-ID: <1291914732.4063.75.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 décembre 2010 à 17:17 +0100, Martin Lucina a écrit :
> Hi,
> 
> so, today we spent all day figuring out how the kernel_sendmsg() function
> *actually* works. This patch adds some documentation to help the next poor
> sod.
> 

Network patches should be sent to netdev@vger.kernel.org and David
Miller, as mentioned in MAINTAINERS file :

NETWORKING [GENERAL]
M:      "David S. Miller" <davem@davemloft.net>
L:      netdev@vger.kernel.org
W:      http://www.linuxfoundation.org/en/Net
W:      http://patchwork.ozlabs.org/project/netdev/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
S:      Maintained
F:      net/
F:      include/net/
F:      include/linux/in.h
F:      include/linux/net.h
F:      include/linux/netdevice.h



> -mato
> 
> From b29ccddeec4b782d710ffe34e0e5e4a0f5e9c24b Mon Sep 17 00:00:00 2001
> From: Martin Lucina <mato@kotelna.sk>
> Date: Thu, 9 Dec 2010 17:11:18 +0100
> Subject: [PATCH] Document the kernel_recvmsg() function
> 
> Signed-off-by: Martin Lucina <mato@kotelna.sk>
> ---
>  net/socket.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 3ca2fd9..b17333d 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -732,6 +732,21 @@ static int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
>  	return ret;
>  }
>  
> +/**
> + * kernel_recvmsg() - Receive a message from a socket (kernel space)

no need for ()

> + * @sock:       The socket to receive the message from
> + * @msg:        Received message
> + * @vec:        Input s/g array for message data
> + * @num:        Size of input s/g array
> + * @size:       Number of bytes to read
> + * @flags:      Message flags (MSG_DONTWAIT, etc...)
> + *
> + * On return the msg structure contains the scatter/gather array passed in the
> + * vec argument. The array is modified so that it consists of the unfilled
> + * portion of the original array.
> + *
> + * The returned value is the total number of bytes received, or an error.
> + */
>  int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
>  		   struct kvec *vec, size_t num, size_t size, int flags)
>  {


