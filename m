Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0HIUTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:19:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33101 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab0HIUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dIqnoqJx6Z2CMiOSfxF0uK3gJhvyotvL8FzKcDS6vfrhHuEaddVtYUgUzlJXAFQmvP
         v/bt0QhEiBBrXq8ZBAx2fI9pxd7Qd79Ot2rMTKpbd1tlYhhdM445LadjNu5faPkw9t4B
         yUMOvmdBKMwHFAC2SwNG1o+LbNrTgMd15aSTc=
Message-ID: <4C6062BA.4070009@gmail.com>
Date: Mon, 09 Aug 2010 22:19:06 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18 v2] char: mxser: call disable_pci_device() if pci_probe()
 failed
References: <1281383369-13613-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1281383369-13613-1-git-send-email-segooon@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 09:49 PM, Kulikov Vasiliy wrote:
> --- a/drivers/char/mxser.c
> +++ b/drivers/char/mxser.c
> @@ -2564,8 +2564,11 @@ static int __devinit mxser_probe(struct pci_dev *pdev,
>  	/* vector */
>  	ioaddress = pci_resource_start(pdev, 3);
>  	retval = pci_request_region(pdev, 3, "mxser(vector)");
> -	if (retval)
> -		goto err_relio;
> +	if (retval) {
> +		pci_release_region(pdev, 2);
> +		brd->info = NULL;
> +		goto err_release;
> +	}

Hi, I'm still not happy with this patch. First, it omits mxser_remove,
where pci_disable_device is not called too. Second, the fail-paths tail
should be reorganized so that we can jump there appropriately. I'll
reply with my version of the patch, if you don't mind.

thanks,
-- 
js
