Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1CNLdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:33:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44242 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1CNLdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:33:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=teeAXhdaMGLLUMwcr1blnFWBXIppRHQQeTrWwR6pRk0i14IdR+Elo+hzyGrBzLk9g5
         Yn/5srPm9jo9dRvsrxl7VrJHDwFmA02q7SO0LiWqhMvNmY/hP+UBb+uJ3Dz2Gdgye8XM
         GtAPVfF6e/T+m+snaxrnMfhV+9cCX57E34sNY=
Date: Mon, 14 Mar 2011 19:32:58 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        greg@kroah.com, joe@perches.com, akpm@linux-foundation.org
Subject: Re: [PATCH][rfc] Use int as return type of main in
 arch/x86/boot/main.c
Message-ID: <20110314113254.GA2761@gmail.com>
Mail-Followup-To: Jesper Juhl <jj@chaosbits.net>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, greg@kroah.com, joe@perches.com,
	akpm@linux-foundation.org
References: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 11:00:09PM +0100, Jesper Juhl wrote:
> I believe the return type of main should always be 'int'.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  main.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
> index 40358c8..4b80da8 100644
> --- a/arch/x86/boot/main.c
> +++ b/arch/x86/boot/main.c
> @@ -125,7 +125,7 @@ static void init_heap(void)
>  	}
>  }
>  
> -void main(void)
> +int main(void)
>  {
>  	/* First, copy the boot header into the "zeropage" */
>  	copy_boot_params();
> @@ -175,4 +175,6 @@ void main(void)
>  
>  	/* Do the last things and invoke protected mode */
>  	go_to_protected_mode();
> +
> +	return 0;
>  }
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Plain text mails only, please.
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
