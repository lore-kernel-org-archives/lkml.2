Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1FNH40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:56:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41738 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab1FNH4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k7UAp4bMmiUYD+hos4/wZRhSQOQAwVFwwo+8O0lq7drEC4GhJBgYk5/7aH90fTff/k
         B1yjYjA8fNegIx7xZZK2wBf9yAzTXymbwHrMqfC667MqYK1/XHFdtsC6AMMtNgCrHcmE
         o8ykJu1Opv3a5+8E6icJzZrUgcBybyK/6GBl4=
MIME-Version: 1.0
In-Reply-To: <486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
References: <cover.1308024069.git.joe@perches.com>
	<486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
Date: Tue, 14 Jun 2011 00:56:22 -0700
Message-ID: <BANLkTi=k-noagFZv-tZbx2FyZ-uBzwP=KA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] drivers/net: Remove casts of void *
From: Debashis Dutt <debdut@gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/net/bna/bfa_cee.c b/drivers/net/bna/bfa_cee.c
> index f7b789a..dcfbf08 100644
> --- a/drivers/net/bna/bfa_cee.c
> +++ b/drivers/net/bna/bfa_cee.c
> @@ -236,7 +236,7 @@ static void
>  bfa_cee_hbfail(void *arg)
>  {
>        struct bfa_cee *cee;
> -       cee = (struct bfa_cee *) arg;
> +       cee = arg;
>
>        if (cee->get_attr_pending == true) {
>                cee->get_attr_status = BFA_STATUS_FAILED;
> diff --git a/drivers/net/bna/cna.h b/drivers/net/bna/cna.h
> index bbd39dc..3c47dc5 100644
> --- a/drivers/net/bna/cna.h
> +++ b/drivers/net/bna/cna.h
> @@ -74,7 +74,7 @@ typedef struct mac { u8 mac[MAC_ADDRLEN]; } mac_t;
>                bfa_q_next(_q) = bfa_q_next(*((struct list_head **) _qe)); \
>                bfa_q_qe_init(*((struct list_head **) _qe));            \
>        } else {                                                        \
> -               *((struct list_head **) (_qe)) = (struct list_head *) NULL; \
> +               *((struct list_head **)(_qe)) = NULL;                   \
>        }                                                               \
>  }
>

"bna" patches look good.

Thanks
--Debashis
