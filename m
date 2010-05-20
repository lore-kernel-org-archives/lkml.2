Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0ETQqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:46:30 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:40511 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0ETQq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=DKG/VpY90oFch6RkzIc9mU8aUeL+adMuIN7PwxqJDQCTNCgZ5906fMa6J/KDzjF25f
         jKSfiK2hKaIzLtgHOUF5B4Imt6XZKAbZmWXUx0aS8R370dJKnS/JvDWtsqd+hSyKjUon
         0Q7s29ussEfeBa11k+hod7mSEYO10looUOzXw=
Message-ID: <4BF56768.5080704@gmail.com>
Date: Thu, 20 May 2010 09:46:32 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jens.Kuenzer@fpga.homeip.net, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][bisected]pcmcia:yenta_socket.c fix broken wireless cards.
References: <1274303284-21529-1-git-send-email-justinmattock@gmail.com> <20100520145434.GA12166@comet.dominikbrodowski.net> <4BF55AC9.4000905@gmail.com> <20100520163419.GA16522@comet.dominikbrodowski.net>
In-Reply-To: <20100520163419.GA16522@comet.dominikbrodowski.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 09:34 AM, Dominik Brodowski wrote:
> Jens, Justin,
>
> could both of you test this patch on top of 2.6.34, please?
>
> pcmcia: only keep saved I365_CSCING flag if there is no PCI irq
>
> Signed-off-by: Dominik Brodowski<linux@dominikbrodowski.net>
>
> diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
> index 424e576..151ca43 100644
> --- a/drivers/pcmcia/yenta_socket.c
> +++ b/drivers/pcmcia/yenta_socket.c
> @@ -371,8 +371,11 @@ static int yenta_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
>   			exca_writeb(socket, I365_POWER, reg);
>
>   		/* CSC interrupt: no ISA irq for CSC */
> -		reg = exca_readb(socket, I365_CSCINT);
> -		reg&= I365_CSC_IRQ_MASK;
> +		reg = 0;
> +		if (!socket->dev->irq) {
> +			reg = exca_readb(socket, I365_CSCINT);
> +			reg&= I365_CSC_IRQ_MASK;
> +		}
>   		reg |= I365_CSC_DETECT;
>   		if (state->flags&  SS_IOCARD) {
>   			if (state->csc_mask&  SS_STSCHG)
>


o.k., I just did a git pull
to the current, now waiting
(compiling)very slow machine) then I'll
verify or not, if a fix has already been
pushed forward, if not then I'll apply
your patch.

Thanks for taking the time with this.

Justin P. Mattock
