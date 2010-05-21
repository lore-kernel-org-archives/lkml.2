Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445Ab0EURWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:22:55 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47614 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934369Ab0EURWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:22:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=jyqIHTg38Pt559Hp3+w8IFCx6m1PEReHkpL+0WmCaDasigaqMIfbd5Wlxj1dYxa3WK
         q9GfV/Se+FzN2rUbQRWs6HeyIp4Unp6CgqYr2iMXXygdzZ5+UcizSy1oPn0YH+SWhoZk
         QxcbfY39IDmvYcoEnzU69hiXtRGPCgDo1yYCM=
Message-ID: <4BF6C171.7040603@gmail.com>
Date: Fri, 21 May 2010 10:22:57 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]pacmcia:yena_socket.c Remove extra #ifdef CONFIG_YENTA_TI
References: <1274388002-2132-1-git-send-email-justinmattock@gmail.com> <20100521131851.GB22685@comet.dominikbrodowski.net>
In-Reply-To: <20100521131851.GB22685@comet.dominikbrodowski.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2010 06:18 AM, Dominik Brodowski wrote:
> Applied (see below), thanks.
>
> Best,
> 	Dominik
>
> From: Justin P. Mattock<justinmattock@gmail.com>
> Date: Thu, 20 May 2010 13:40:02 -0700
> Subject: [PATCH] pcmcia: yenta_socket.c Remove extra #ifdef CONFIG_YENTA_TI
>
> Seems pointless to have two #ifdef's with the same
> CONFIG_YENTA_TI.. Remove the extra one and
> move CARDBUS_TYPE_ENE with the others.
>
> [linux@dominikbrodowski.net: spelling&  whitespace fixes]
> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> Signed-off-by: Dominik Brodowski<linux@dominikbrodowski.net>
>
> diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
> index 6bf8b2c..f1d4137 100644
> --- a/drivers/pcmcia/yenta_socket.c
> +++ b/drivers/pcmcia/yenta_socket.c
> @@ -880,6 +880,12 @@ static struct cardbus_type cardbus_type[] = {
>   		.restore_state	= ti_restore_state,
>   		.sock_init	= ti_init,
>   	},
> +	[CARDBUS_TYPE_ENE]	= {
> +		.override	= ene_override,
> +		.save_state	= ti_save_state,
> +		.restore_state	= ti_restore_state,
> +		.sock_init	= ti_init,
> +	},
>   #endif
>   #ifdef CONFIG_YENTA_RICOH
>   	[CARDBUS_TYPE_RICOH]	= {
> @@ -902,14 +908,6 @@ static struct cardbus_type cardbus_type[] = {
>   		.restore_state	= o2micro_restore_state,
>   	},
>   #endif
> -#ifdef CONFIG_YENTA_TI
> -	[CARDBUS_TYPE_ENE]	= {
> -		.override	= ene_override,
> -		.save_state	= ti_save_state,
> -		.restore_state	= ti_restore_state,
> -		.sock_init	= ti_init,
> -	},
> -#endif
>   };
>
>
>
>


cool..

As for the problem with
pcmcia, I've my machine ready to take anything
but am in no real hurry with it(was more curious
how 2.6.34 ran on the old beast of a machine).

I'll go and send the bug report to Raphael
so he can add it to the list of regressions,
then down the line if something comes up
I can test it out or something..

Justin P. Mattock
