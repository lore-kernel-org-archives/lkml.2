Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2HII7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 04:59:24 -0400
Received: from mail-qc0-f184.google.com ([209.85.216.184]:54967 "EHLO
	mail-qc0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab2HII7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 04:59:22 -0400
X-Greylist: delayed 1863 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2012 04:59:22 EDT
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Thu, 9 Aug 2012 01:17:11 -0700 (PDT)
In-Reply-To: <fa.lacg30v.3h8di4@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=82.213.2.186; posting-account=S59YrgoAAAC02Kx9mcoQE5h5ezYi4goP
NNTP-Posting-Host: 82.213.2.186
References: <fa.hi9ib1v.1d6a50s@ifi.uio.no> <fa.lacg30v.3h8di4@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 82.213.2.186
MIME-Version: 1.0
Message-ID: <251e1b72-9ffb-497e-962d-d711a0958c57@googlegroups.com>
Subject: Re: recv(...,MSG_TRUNC)
From: ibrahem.batta@gmail.com
To: fa.linux.kernel@googlegroups.com
Cc: Alan.Cox@linux.org, linux-net@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Samuel Thibault <samuel.thibault@fnac.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 29, 2002 10:40:18 PM UTC+3, Samuel Thibault wrote:
> (Previous mail seemed to be garbaged by mime attachment)
> 
> Hello,
> 
> man recv says, about flags :
> 
>        MSG_TRUNC
>               Return  the real length of the packet, even when it
>               was longer than the passed buffer. Only  valid  for
>               packet sockets.
> 
> But it is neither implemented in ipv4/udp.c, nor in ipv6/udp.c, although
> it is in tcp.c, for instance !
> 
> By searching with google, I could read old manpages where it didn't exist,
> but I find it very useful, especially in conjunction with MSG_PEEK, for
> trying to read a packet with a little buffer, and then really get it with
> an appropriate buffer.
> 
> So here's a patch which cures 2.4.18, and also works on 2.5 kernels.
> 
> Best regards,
> 
> Samuel Thibault
> 
> diff -urN linux-2.4.18/net/ipv4/udp.c linux-2.4.18-cor/net/ipv4/udp.c
> --- linux-2.4.18/net/ipv4/udp.c	Mon Jun 10 23:34:59 2002
> +++ linux-2.4.18-cor/net/ipv4/udp.c	Mon Jun 10 23:35:31 2002
> @@ -680,7 +680,7 @@
>    	}
>  	if (sk->protinfo.af_inet.cmsg_flags)
>  		ip_cmsg_recv(msg, skb);
> -	err = copied;
> +	err = (flags&MSG_TRUNC) ? skb->len - sizeof(struct udphdr) : copied;
> 
>  out_free:
>    	skb_free_datagram(sk, skb);
> diff -urN linux-2.4.18/net/ipv6/udp.c linux-2.4.18-cor/net/ipv6/udp.c
> --- linux-2.4.18/net/ipv6/udp.c	Mon Jun 10 23:35:07 2002
> +++ linux-2.4.18-cor/net/ipv6/udp.c	Mon Jun 10 23:35:36 2002
> @@ -432,7 +432,7 @@
>  			}
>  		}
>    	}
> -	err = copied;
> +	err = (flags&MSG_TRUNC) ? skb->len - sizeof(struct udphdr) : copied;
> 
>  out_free:
>  	skb_free_datagram(sk, skb);
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

man i want to see full example about receivefrom and MSG_TRUNC flag please 
