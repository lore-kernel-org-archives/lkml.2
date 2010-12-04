Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0LDBwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 20:52:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42215 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0LDBwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 20:52:07 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=Fuv6IjjYP5wA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=jO8t4-Zo9zUZsS_XFdUA:9 a=Gk6isQFC899y6pZdPLEA:7 a=wyB1v84AAHdOegz0KjV4Cq_udu4A:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 09/15] ftrace: fix event alignment: skb:kfree_skb
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Neil Horman <nhorman@tuxdriver.com>
In-Reply-To: <1291421609-14665-10-git-send-email-dhsharp@google.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-10-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Dec 2010 20:52:05 -0500
Message-ID: <1291427525.16223.11.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Ccing Neil for Acked-by ]

-- Steve


On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  include/trace/events/skb.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> index 75ce9d5..aa4a56a 100644
> --- a/include/trace/events/skb.h
> +++ b/include/trace/events/skb.h
> @@ -19,16 +19,16 @@ TRACE_EVENT(kfree_skb,
>  
>  	TP_STRUCT__entry(
>  		__field(	void *,		skbaddr		)
> -		__field(	unsigned short,	protocol	)
>  		__field(	void *,		location	)
> +		__field(	unsigned short,	protocol	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->skbaddr = skb;
> +		__entry->location = location;
>  		if (skb) {
>  			__entry->protocol = ntohs(skb->protocol);
>  		}
> -		__entry->location = location;
>  	),
>  
>  	TP_printk("skbaddr=%p protocol=%u location=%p",


