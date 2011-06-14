Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1FNJV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:21:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab1FNJVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HjleCL8p59ggVjGHzONr9jnB6a8eojIUlbWBFJ6PHAQtfNoyW3OH2hmzIJ6oeToN9I
         E9iSX0nSWFNOG4SnPI99YdnLSFaVzcO2yQoY5Y1ra0eDShHODehjS79GsGLcBTdIg1x2
         XCDV700gv7rRWPvyC1ccMd2RLojsedex97FGA=
MIME-Version: 1.0
In-Reply-To: <486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
References: <cover.1308024069.git.joe@perches.com>
	<486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
Date: Tue, 14 Jun 2011 11:21:03 +0200
X-Google-Sender-Auth: NAwvdr1VoqB-yGy3TN9FaeJpsmk
Message-ID: <BANLkTim-yLJqfxrCprwiTgdRJNy+OGDUuw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] drivers/net: Remove casts of void *
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        Jie Yang <jie.yang@atheros.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        Subbu Seetharaman <subbu.seetharaman@emulex.com>,
        Ajit Khaparde <ajit.khaparde@emulex.com>,
        Rasesh Mody <rmody@brocade.com>, Debashis Dutt <ddutt@brocade.com>,
        Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Divy Le Ray <divy@chelsio.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        Amit Kumar Salecha <amit.salecha@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        Jon Mason <jdmason@kudzu.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Steve Hodgson <shodgson@solarflare.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Daniele Venzano <venza@brownhat.org>,
        David Dillow <dave@thedillows.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 06:02, Joe Perches <joe@perches.com> wrote:
> Unnecessary casts of void * clutter the code.

> --- a/drivers/net/a2065.c
> +++ b/drivers/net/a2065.c
> @@ -426,7 +426,7 @@ static irqreturn_t lance_interrupt (int irq, void *dev_id)
>        volatile struct lance_regs *ll;
>        int csr0;
>
> -       dev = (struct net_device *) dev_id;
> +       dev = dev_id;

I think it would look better if you merge this line with the line that
defines "dev".

>
>        lp = netdev_priv(dev);
>        ll = lp->ll;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
