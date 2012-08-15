Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2HOVHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:07:17 -0400
Received: from mxweb02do.versatel-west.de ([62.214.96.173]:57098 "HELO
	mxweb02do.versatel-west.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756622Ab2HOVHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:07:15 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 17:07:14 EDT
Message-ID: <502C0DEC.3010104@cinnamon-sage.de>
Date: Wed, 15 Aug 2012 23:00:28 +0200
From: Lars Hanisch <dvb@cinnamon-sage.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] [media] ddbridge: fix error handling in module_init_ddbridge()
References: <1345063345-31131-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1345063345-31131-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 15.08.2012 22:42, schrieb Alexey Khoroshilov:
> If pci_register_driver() failed, resources allocated in
> ddb_class_create() are leaked. The patch fixes it.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/media/dvb/ddbridge/ddbridge-core.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
> index ebf3f05..36aa4e4 100644
> --- a/drivers/media/dvb/ddbridge/ddbridge-core.c
> +++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
> @@ -1705,7 +1705,11 @@ static __init int module_init_ddbridge(void)
>  	       "Copyright (C) 2010-11 Digital Devices GmbH\n");
>  	if (ddb_class_create())
>  		return -1;
> -	return pci_register_driver(&ddb_pci_driver);
> +	if (pci_register_driver(&ddb_pci_driver) < 0) {
> +		ddb_class_destroy();
> +		return -1;

 Difference to before: the return value of pci_register_driver is not passed through.
 Is this a problem? I'm just an interested application developer, not a driver developer.

Regards,
Lars.

> +	}
> +	return 0;
>  }
>  
>  static __exit void module_exit_ddbridge(void)
>
