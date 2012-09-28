Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031912Ab2I1ViD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:38:03 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:34944 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab2I1Vh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:37:58 -0400
Message-ID: <506618BA.4070509@calxeda.com>
Date: Fri, 28 Sep 2012 16:38:02 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [PATCH 02/12] ata: mark probe function as __devinit rather than
 __init
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1348868177-21205-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2012 04:36 PM, Arnd Bergmann wrote:
> Functions for hotplugging must be marked as __devinit so
> they do not get discarded, as pointed out by a build time
> warning from modpost.
> 
> Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/ata/sata_highbank.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
> index 0d7c4c2..36a141a 100644
> --- a/drivers/ata/sata_highbank.c
> +++ b/drivers/ata/sata_highbank.c
> @@ -260,7 +260,7 @@ static const struct of_device_id ahci_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, ahci_of_match);
>  
> -static int __init ahci_highbank_probe(struct platform_device *pdev)
> +static int __devinit ahci_highbank_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
>  	struct ahci_host_priv *hpriv;

Thanks. I just ran into this today and couldn't figure out the error
message.

Acked-by: Mark Langsdorf <mark.langsdorf@calxeda.com>

--Mark Langsdorf
Calxeda, Inc.

