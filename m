Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1FDVf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 17:35:26 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46658 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1FDVfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 17:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=j2rBEk85MNbUjNdGeVB555fdFVaojdSDAa56+4VV0pAtSnEwcccUgH1Gqv6JAgunKi
         kOYiQSt6lvRg6qebSCQwktRbLnHu+whJFQPx5HBtAZ2q76IsA9Cdj4a4AmjC5JEaoPUw
         x6o2Ilj/ZzVyS/2Dm6tOfoloSDwBdcSsC96cs=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: dbrownell@users.sourceforge.net,
        "Andre Bartke" <andre.bartke@googlemail.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Andre Bartke" <andre.bartke@gmail.com>
Subject: Re: [PATCH] drivers/usb/gadget: add missing kfree calls
References: <1307216094-13570-1-git-send-email-andre.bartke@gmail.com>
Date: Sat, 04 Jun 2011 23:35:16 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vwkl82ut3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1307216094-13570-1-git-send-email-andre.bartke@gmail.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Jun 2011 21:34:54 +0200, Andre Bartke  
<andre.bartke@googlemail.com> wrote:
> diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
> @@ -700,6 +701,7 @@ static int rndis_reset_response(int configNr,  
> rndis_reset_msg_type *buf)
>  	resp->AddressingReset = cpu_to_le32(1);
> 	params->resp_avail(params->v);
> +	kfree(r);
>  	return 0;
>  }

Have you tested this?  It does not look right to me.  rndis_add_response()
allocates memory and puts the request on a list.  It is later freed in
rndis_free_response().

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
