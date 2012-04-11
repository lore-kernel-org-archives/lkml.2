Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762Ab2DKRGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:06:18 -0400
Received: from www84.your-server.de ([213.133.104.84]:47729 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab2DKRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:06:17 -0400
X-Greylist: delayed 1037 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2012 13:06:16 EDT
Message-ID: <1334162939.16577.2.camel@wall-e>
Subject: Re: [PATCH 3.3.0] kernel:kfifo: export __kfifo_max_r symbol.
From: Stefani Seibold <stefani@seibold.net>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Date: Wed, 11 Apr 2012 18:48:59 +0200
In-Reply-To: <1334131316-7992-1-git-send-email-srinivas.kandagatla@st.com>
References: <1334131316-7992-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locks okay to me.

Acked-by: Stefani Seibold <stefani@seibold.net>

Am Mittwoch, den 11.04.2012, 09:01 +0100 schrieb Srinivas KANDAGATLA:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> kfifo_avail expands to __kfifo_max_r which is not an exported symbol.
> Any kernel module using kfifo_avail will result in build failures
> because of this.
> This patch just exports __kfifo_max_r symbol to fix such problems in
> future.
> 
> This bug was orignially reported by Stephen Rothwell <sfr@canb.auug.org.au> 
> during v4l-dvb tree integration into linux-next.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
> Hi All, 
> A bulid failure during v4l-dvb tree integration into linux-next shows that __kfifo_max_r symbol is not exported.
> All the __kifo_* functions declared in kfifo.h are already exported symbols.
> I see no reason why __kfifo_max_r should not be exported too.
> 
> comments?
> 
> --srini
> 
>  kernel/kfifo.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/kfifo.c b/kernel/kfifo.c
> index c744b88..59dcf5b 100644
> --- a/kernel/kfifo.c
> +++ b/kernel/kfifo.c
> @@ -402,6 +402,7 @@ unsigned int __kfifo_max_r(unsigned int len, size_t recsize)
>  		return max;
>  	return len;
>  }
> +EXPORT_SYMBOL(__kfifo_max_r);
>  
>  #define	__KFIFO_PEEK(data, out, mask) \
>  	((data)[(out) & (mask)])


