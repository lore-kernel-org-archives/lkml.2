Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1LLJaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:30:35 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:28816 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1LLJae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:30:34 -0500
X-IronPort-AV: E=Sophos;i="4.71,337,1320624000"; 
   d="scan'208";a="9410180"
Subject: Re: [Xen-devel] [PATCH 6/6] xen/xenbus-backend: Only register
 device if communication ring is local
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Bastian Blank <waldi@debian.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Mon, 12 Dec 2011 09:30:33 +0000
In-Reply-To: <1323541791-18006-7-git-send-email-waldi@debian.org>
References: <1323541791-18006-1-git-send-email-waldi@debian.org>
	 <1323541791-18006-7-git-send-email-waldi@debian.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323682233.20077.100.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-10 at 18:29 +0000, Bastian Blank wrote:
> +/* A flag to determine if xenstored is 'local' */
> +#ifdef CONFIG_XEN_BACKEND
> +static int xenstored_local;
> +#endif

I think this can be __initdata since all the users are __init.

> +#ifdef CONFIG_XEN_BACKEND
> +			xenstored_local = 1;

I would push this down into xenstore_local_init() and only set it on
success.

>  			err = xenstored_local_init();

This is now only called if CONFIG_XEN_BACKEND. You should add a similar
#ifdef around the function definition.

Ian.

>  			if (err)
>  				goto out_error;
> +#else
> +			BUG();
> +#endif
>  		}
>  		xen_store_interface = mfn_to_virt(xen_store_mfn);
>  	}


