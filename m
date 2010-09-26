Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0IZJ0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:26:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0IZJ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bag+qt1eLV33SUZWuGd/wWkLVvdPMOjyXR3p07eyXntJkzyWq4c1gOOqekkrJ6VshO
         /U0P0/NiNAKl+S7XCjlaufMjxKAxVQVx8pc46rHlr3jXyLLZe10+DaL6ULixpB008utQ
         STNzhxT61TJNq27G82nqnyuQATdGBgzT8cwfg=
Message-ID: <4C9F11A9.7040808@gmail.com>
Date: Sun, 26 Sep 2010 12:26:01 +0300
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Rahul Ruikar <rahul.ruikar@gmail.com>
CC: ak@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: phantom: Added missing warning messages in phantom_probe
References: <1285422505-7128-1-git-send-email-rahul.ruikar@gmail.com>
In-Reply-To: <1285422505-7128-1-git-send-email-rahul.ruikar@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2010 04:48 PM, Rahul Ruikar wrote:
> phantom_probe can fail at many places. missing warning messages
> have been added for 2 cases.
> pci_enable_device()
> pci_request_regions()
> 
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>

Acked-by: Jiri Slaby <jirislaby@gmail.com>

Andrew, could you take it?

> ---
>  drivers/misc/phantom.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
> index 75ee0d3..b4c105f 100644
> --- a/drivers/misc/phantom.c
> +++ b/drivers/misc/phantom.c
> @@ -341,8 +341,10 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
>  	int retval;
>  
>  	retval = pci_enable_device(pdev);
> -	if (retval)
> +	if (retval) {
> +		dev_err(&pdev->dev, "pci_enable_device failed!\n");
>  		goto err;
> +	}
>  
>  	minor = phantom_get_free();
>  	if (minor == PHANTOM_MAX_MINORS) {
> @@ -354,8 +356,10 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
>  	phantom_devices[minor] = 1;
>  
>  	retval = pci_request_regions(pdev, "phantom");
> -	if (retval)
> +	if (retval) {
> +		dev_err(&pdev->dev, "pci_request_regions failed!\n");
>  		goto err_null;
> +	}
>  
>  	retval = -ENOMEM;
>  	pht = kzalloc(sizeof(*pht), GFP_KERNEL);

thanks,
-- 
js
