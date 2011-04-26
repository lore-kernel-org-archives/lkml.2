Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab1DZBQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:16:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17022 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab1DZBQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:16:04 -0400
Date: Mon, 25 Apr 2011 18:15:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n_gsm: Use print_hex_dump_bytes
Message-Id: <20110425181551.c7d23c31.randy.dunlap@oracle.com>
In-Reply-To: <1303775210.23494.6.camel@Joe-Laptop>
References: <65136ab68431de0cc0c554663cee33fc9d4a9850.1303615717.git.joe@perches.com>
	<20110425082230.6d656ed0.randy.dunlap@oracle.com>
	<1303775210.23494.6.camel@Joe-Laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DB61CCD.000E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011 16:46:49 -0700 Joe Perches wrote:

> Use the standard mechanism to print a hex buffer
> to eliminate empty printf warning.
> 
> A couple % smaller text and data too.
> 
> $ size drivers/tty/n_gsm.o*
>    text	   data	    bss	    dec	    hex	filename
>   23543	    312	   6376	  30231	   7617	drivers/tty/n_gsm.o.new
>   24051	    408	   6496	  30955	   78eb	drivers/tty/n_gsm.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, Joe.


> ---
>  drivers/tty/n_gsm.c |   35 ++++++++++-------------------------
>  1 files changed, 10 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index 74273e6..b0fcffc 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -526,19 +526,6 @@ static int gsm_stuff_frame(const u8 *input, u8 *output, int len)
>  	return olen;
>  }
>  
> -static void hex_packet(const unsigned char *p, int len)
> -{
> -	int i;
> -	for (i = 0; i < len; i++) {
> -		if (i && (i % 16) == 0) {
> -			pr_cont("\n");
> -			pr_debug("");
> -		}
> -		pr_cont("%02X ", *p++);
> -	}
> -	pr_cont("\n");
> -}
> -
>  /**
>   *	gsm_send	-	send a control frame
>   *	@gsm: our GSM mux
> @@ -685,10 +672,10 @@ static void gsm_data_kick(struct gsm_mux *gsm)
>  			len = msg->len + 2;
>  		}
>  
> -		if (debug & 4) {
> -			pr_debug("gsm_data_kick:\n");
> -			hex_packet(gsm->txframe, len);
> -		}
> +		if (debug & 4)
> +			print_hex_dump_bytes("gsm_data_kick: ",
> +					     DUMP_PREFIX_OFFSET,
> +					     gsm->txframe, len);
>  
>  		if (gsm->output(gsm, gsm->txframe + skip_sof,
>  						len - skip_sof) < 0)
> @@ -2095,10 +2082,9 @@ static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
>  		set_bit(TTY_DO_WRITE_WAKEUP, &gsm->tty->flags);
>  		return -ENOSPC;
>  	}
> -	if (debug & 4) {
> -		pr_debug("-->%d bytes out\n", len);
> -		hex_packet(data, len);
> -	}
> +	if (debug & 4)
> +		print_hex_dump_bytes("gsmld_output: ", DUMP_PREFIX_OFFSET,
> +				     data, len);
>  	gsm->tty->ops->write(gsm->tty, data, len);
>  	return len;
>  }
> @@ -2152,10 +2138,9 @@ static void gsmld_receive_buf(struct tty_struct *tty, const unsigned char *cp,
>  	char buf[64];
>  	char flags;
>  
> -	if (debug & 4) {
> -		pr_debug("Inbytes %dd\n", count);
> -		hex_packet(cp, count);
> -	}
> +	if (debug & 4)
> +		print_hex_dump_bytes("gsmld_receive: ", DUMP_PREFIX_OFFSET,
> +				     cp, count);
>  
>  	for (i = count, dp = cp, f = fp; i; i--, dp++) {
>  		flags = *f++;
> -- 



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
