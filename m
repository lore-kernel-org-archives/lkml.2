Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1AVNzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:55:11 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43221 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906Ab1AVNzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:55:09 -0500
Message-Id: <1295704508.21026.1416646721@webmail.messagingengine.com>
X-Sasl-Enc: 9eQxRPuFbLH/hYXtrfP2Ar4mKYjMwcUP/ZlzuD7ISi0B 1295704508
From: "Clemens Ladisch" <clemens@ladisch.de>
To: "Jesper Juhl" <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, "Takashi Iwai" <tiwai@suse.de>,
        "Jaroslav Kysela" <perex@perex.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <alpine.LNX.2.00.1101202228370.11854@swampdragon.chaosbits.net>
Subject: Re: [PATCH][RFC] Sound, Xonar, CS43xx: Don't overrun static array
In-Reply-To: <alpine.LNX.2.00.1101202228370.11854@swampdragon.chaosbits.net>
Date: Sat, 22 Jan 2011 14:55:08 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> 'cs4398_regs' in 'struct xonar_cs43xx' is an array of 'u8' with a size of 
> 8. So, this code in sound/pci/oxygen/xonar_cs43xx.c::dump_d1_registers()
> 
>     		for (i = 2; i <= 8; ++i)
> 	  			snd_iprintf(buffer, " %02x", data->cs4398_regs[i]);
> 
> will overrun the array when 'i == 8'.
> 
> I guess that what's needed to fix it is the trivial patch below, but I 
> must admit that I have no idea about this code, so I may very well be 
> wrong. Additionally, I have no way to actually test this, so all I know is 
> that the below compiles. Someone who actually knows this code should take 
> a look before anything is comitted - consider the below (not much more 
> than) a bug report.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Clemens Ladisch <clemens@ladisch.de>

> ---
>  xonar_cs43xx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/pci/oxygen/xonar_cs43xx.c
> b/sound/pci/oxygen/xonar_cs43xx.c
> index 9f72d42..2527191 100644
> --- a/sound/pci/oxygen/xonar_cs43xx.c
> +++ b/sound/pci/oxygen/xonar_cs43xx.c
> @@ -392,7 +392,7 @@ static void dump_d1_registers(struct oxygen *chip,
>  	unsigned int i;
>  
>  	snd_iprintf(buffer, "\nCS4398: 7?");
> -       for (i = 2; i <= 8; ++i)
> +       for (i = 2; i < 8; ++i)
>  		snd_iprintf(buffer, " %02x", data->cs4398_regs[i]);
>  	snd_iprintf(buffer, "\n");
>  	dump_cs4362a_registers(data, buffer);
