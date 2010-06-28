Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0F1NMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:12:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34437 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab0F1NMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GWDsoQl2LwOUwXqz+3S1tdNTl+/ltDlegEN2e30TCsRELf/e8dqW/gZ5xL4LXmA+X+
         8LZ8M6lvPlyw6OIQOARMdQkMBJJcHX6Zml1jxbIQJp9ScGeK78V/PxiL5vVkzcyZrzOT
         H9NJKaEdyiaLYd8FqmnZFM3Vm021MU1mlXlW0=
Date: Mon, 28 Jun 2010 10:12:30 -0300
From: "Gustavo F. Padovan" <gustavo@padovan.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-bluetooth@vger.kernel.org, justinmattock@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix abuse of the preincrement operator
Message-ID: <20100628131058.GA25275@vigoh>
References: <1277621246-10960-6-git-send-email-justinmattock@gmail.com>
 <20100628125752.8945.50572.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628125752.8945.50572.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

* David Howells <dhowells@redhat.com> [2010-06-28 13:57:52 +0100]:

> Fix abuse of the preincrement operator as detected when building with gcc
> 4.6.0:
> 
> 	 CC [M]  drivers/bluetooth/hci_bcsp.o
> 	drivers/bluetooth/hci_bcsp.c: In function 'bcsp_prepare_pkt':
> 	drivers/bluetooth/hci_bcsp.c:247:20: warning: operation on 'bcsp->msgq_txseq' may be undefined
> 
> Reported-by: Justin P. Mattock <justinmattock@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  drivers/bluetooth/hci_bcsp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
> index 40aec0f..42d69d4 100644
> --- a/drivers/bluetooth/hci_bcsp.c
> +++ b/drivers/bluetooth/hci_bcsp.c
> @@ -244,7 +244,7 @@ static struct sk_buff *bcsp_prepare_pkt(struct bcsp_struct *bcsp, u8 *data,
>  	if (rel) {
>  		hdr[0] |= 0x80 + bcsp->msgq_txseq;
>  		BT_DBG("Sending packet with seqno %u", bcsp->msgq_txseq);
> -		bcsp->msgq_txseq = ++(bcsp->msgq_txseq) & 0x07;
> +		bcsp->msgq_txseq = (bcsp->msgq_txseq + 1) & 0x07;
>  	}
>  
>  	if (bcsp->use_crc)
> 

Acked-by: Gustavo F. Padovan <padovan@profusion.mobi>

-- 
Gustavo F. Padovan
http://padovan.org
