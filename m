Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1DEQBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:01:42 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1DEQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=UgNj67RzrRmK3bMI72me3Puh5s4VknTbRhpFCD6VYIYy08ZGVqidLaQrZjSsnmxWwy
         uLnn9kM2jYA7Zzcnrx2qOCN3Iuxgb6gNHZBPr3+DhEIvRm+44BMaC4LiQn8LFoexlbfC
         RUcnQYg431jL/z2ptZu9hYL+LGOoue4eDRBps=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb: gadget: f_mass_storage: remove unnecessary
 initialization
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
 <1302017802-16614-6-git-send-email-roger.quadros@nokia.com>
Date: Tue, 05 Apr 2011 18:01:36 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vtg2syen3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302017802-16614-6-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 17:36:42 +0200, Roger Quadros wrote:
> memset sets the entire data structure to zero, so no need to
> zero initialize its field again.
>
> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
> ---
>  drivers/usb/gadget/f_mass_storage.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_mass_storage.c  
> b/drivers/usb/gadget/f_mass_storage.c
> index 60b4df9..d3c00e6 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2775,7 +2775,6 @@ static struct fsg_common *fsg_common_init(struct  
> fsg_common *common,
>  		common->free_storage_on_release = 1;
>  	} else {
>  		memset(common, 0, sizeof *common);
> -		common->free_storage_on_release = 0;
>  	}
> 	common->ops = cfg->ops;

Yes, that's correct, but *I* would still leave that for the sake of
symmetry.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
