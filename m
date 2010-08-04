Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab0HDH5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:57:47 -0400
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:48237 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755943Ab0HDH5o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:57:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=6vAGGK0vwjFSI5sMNrzPgZv6qvGHagFXN+D9ofbcDZ32GFTvtEHTU9KpC4JxbCO38O2wtoJrPx74iFCDBrq6AsM2GSz+0Qz1pV5nOHtjtxvBeH3C7xFVjKXSTXqsm1qexX80yTEG9679XdPrZDibiblSlJ1dxT7p5ETK6RtA8XM=;
Message-ID: <811063.41186.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: iKHQHgwVM1l.fd35A4oGw.Fzn5R9v_CQGIlmb66wpbBNv17
 gwiu9umxI.3zpcDLlojvIzVV4_ePprw2mMId9J7CPP6XKoMAyulyF8MbRKBi
 lmFI0Kd0uE9BHDbLw2vJ6RrjRYVg_DuNDcXaiu2WsS_jfUpX5gL0Nv4a5aNh
 V6X_OGaw5VVJz6BBs55I5cozVVlbbZSQ_KC4FQhxhiewv6ZT027tKwi5TuS9
 R.9pG8gTvIQmeHz5U8J5lt7xa0Lvq91qBJvEtkS8KaU2s4jBkJaEzIp_COQG
 YpIOAjGhlX69rmP_13eH_uQX2w.Ov.D8S09q0w6.WGY96_tQD1hazgfv1ZO7
 XgYBUVN7kYxf6
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 4 Aug 2010 00:50:20 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/2] MEMSTICK: fix hangs on unexpected device removal in mspro_blk
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1280847186-11501-2-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 3/8/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> Now that del_gendisk syncs, we better
> start rejecting requests right away.


I don't quite see why this change is needed. My understanding is, user
accessible interface should be marked as removed as early, as possible.


> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/memstick/core/mspro_block.c |    5
> +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/memstick/core/mspro_block.c
> b/drivers/memstick/core/mspro_block.c
> index 8327e24..8d27c13 100644
> --- a/drivers/memstick/core/mspro_block.c
> +++ b/drivers/memstick/core/mspro_block.c
> @@ -1330,13 +1330,14 @@ static void
> mspro_block_remove(struct memstick_dev *card)
>      struct mspro_block_data *msb =
> memstick_get_drvdata(card);
>      unsigned long flags;
>  
> -    del_gendisk(msb->disk);
> -    dev_dbg(&card->dev, "mspro block
> remove\n");
>      spin_lock_irqsave(&msb->q_lock,
> flags);
>      msb->eject = 1;
>      blk_start_queue(msb->queue);
>     
> spin_unlock_irqrestore(&msb->q_lock, flags);
>  
> +    del_gendisk(msb->disk);
> +    dev_dbg(&card->dev, "mspro block
> remove\n");
> +
>      blk_cleanup_queue(msb->queue);
>      msb->queue = NULL;
>  
> -- 
> 1.7.0.4
> 
> 


      
