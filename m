Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab0GWTS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 15:18:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35771 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab0GWTS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TopwmBv0Z05iMWHh72oVP6EHfGgQbLZWvEQ8m/ZBpfiPJYu3ZtmMxExye+9tXVW4Dl
         KTy+cGdhZci+aGLQLP252yziLIl99uXmkl/pfWr7ac7iSSAWWW1Ei9EVeses8AimAayt
         dHcfUGaYm07E6YPWjuDBb3HfDOXqF4x+TtsSQ=
Message-ID: <4C49EB1B.1030700@gmail.com>
Date: Fri, 23 Jul 2010 21:18:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: mxser: remove unnesesary NULL check
References: <1279902893-27006-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1279902893-27006-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 06:34 PM, Kulikov Vasiliy wrote:
> mxser_transmit_chars(tty, port) is called only from mxser_interrupt().
> NULL check is performed in mxser_interrupt() so it is redundant here.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Acked-by: Jiri Slaby <jirislaby@gmail.com>

> ---
>  drivers/char/mxser.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
> index d2692d4..3fc89da 100644
> --- a/drivers/char/mxser.c
> +++ b/drivers/char/mxser.c
> @@ -2193,7 +2193,7 @@ static void mxser_transmit_chars(struct tty_struct *tty, struct mxser_port *port
>  	port->mon_data.up_txcnt += (cnt - port->xmit_cnt);
>  	port->icount.tx += (cnt - port->xmit_cnt);
>  
> -	if (port->xmit_cnt < WAKEUP_CHARS && tty)
> +	if (port->xmit_cnt < WAKEUP_CHARS)
>  		tty_wakeup(tty);
>  
>  	if (port->xmit_cnt <= 0) {


-- 
js
