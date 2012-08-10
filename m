Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab2HJSfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:35:12 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:22721 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759750Ab2HJSfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:35:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFADRTJVBXQCzb/2dsb2JhbABEhTqjJJEMgQiCIAEBBVYGHAEQCwsNCRYPCQMCAQIBERYeBg0BBQIBAYd5AROlZYd9ChmBC4h3iw+GZAOVSYVcijOCYQ
Message-ID: <50255393.7070400@gmail.com>
Date: Fri, 10 Aug 2012 20:31:47 +0200
From: Jan Ceuleers <jan.ceuleers@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Masatake YAMATO <yamato@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/15] Declaring udp protocols has its own proc entry
References: <20120810.230559.1897275934845172399.yamato@redhat.com>
In-Reply-To: <20120810.230559.1897275934845172399.yamato@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2012 04:05 PM, Masatake YAMATO wrote:
> Declaring udp protocols has its own proc entry.
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---
>  net/ipv4/udp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index b4c3582..2b822ac 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1963,6 +1963,9 @@ struct proto udp_prot = {
>  	.compat_getsockopt = compat_udp_getsockopt,
>  #endif
>  	.clear_sk	   = sk_prot_clear_portaddr_nulls,
> +#ifdef CONFIG_PROC_FS
> +	.has_own_proc_entry= 1,
> +#endif
>  };
>  EXPORT_SYMBOL(udp_prot);
>  
> 

Two points:

- I haven't seen patch 01/15;
- these patches should go to netdev rather than lkml
