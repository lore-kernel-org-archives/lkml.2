Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab1LGNjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:39:44 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:6776 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab1LGNjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:39:41 -0500
Message-ID: <4EDF6C44.3050306@parallels.com>
Date: Wed, 07 Dec 2011 17:38:12 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "dave@gnu.org" <dave@gnu.org>
CC: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
Subject: Re: [PATCH] resource cgroups: remove bogus cast
References: <1323119621.3244.1.camel@offbook>
In-Reply-To: <1323119621.3244.1.camel@offbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 01:13 AM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> The memparse() function already accepts const char * as the parsing string.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

> ---
>  kernel/res_counter.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
> index 34683ef..6d269cc 100644
> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -159,8 +159,7 @@ int res_counter_memparse_write_strategy(const char *buf,
>  		return 0;
>  	}
>  
> -	/* FIXME - make memparse() take const char* args */
> -	*res = memparse((char *)buf, &end);
> +	*res = memparse(buf, &end);
>  	if (*end != '\0')
>  		return -EINVAL;
>  

