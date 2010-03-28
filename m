Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab0C1Ex6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 00:53:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35354 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0C1Ex5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 00:53:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Lj44n/eaiKdh8T5cgasBimUKjwbbc+tvh7cFb3qSQ5DS3kNcpw2g9B4zdPzQaGS5Wl
         ZPLfuS9WtOBGs0LX/wCVBDnz/8mtVnJPMltmkiLbDNguaPJkiKqY41HI+raseQOC62Nr
         CbVClf6HCFH9AkZ2fo2TsOnW8iiOFq93xdqBM=
Message-ID: <4BAEE0E1.5030306@garzik.org>
Date: Sun, 28 Mar 2010 00:53:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: JosephChan@via.com.tw
CC: linux-ide@vger.kernel.org, stable@kernel.org, linux-kernel@vger.kernel.org,
       sshtylyov@mvista.com, tj@kernel.org
Subject: Re: [Patch 1/1 v2] pata_via: HDD of VT6410/6415/6330 cannot be detected
 issue
References: <9E058EE846170743AF7338FE064CB5AB38B477@exchtp04.taipei.via.com.tw>
In-Reply-To: <9E058EE846170743AF7338FE064CB5AB38B477@exchtp04.taipei.via.com.tw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 08:51 AM, JosephChan@via.com.tw wrote:
> When using VT6410/6415/6330 chips on some VIA's platforms, the HDD connects to VT6410/6415/6330 cannot be detected.
> It is because the driver detects wrong via_isa_bridge ID, and then cause the this issue happen.
> This patch will fix this problem.
>
>
> Signed-off-by: Joseph Chan<josephchan@via.com.tw>
>
> --- a/drivers/ata/pata_via.c	2010-03-16 06:00:01.000000000 -0400
> +++ b/drivers/ata/pata_via.c	2010-03-25 08:47:15.000000000 -0400
> @@ -576,6 +576,10 @@
>   			u8 rev = isa->revision;
>   			pci_dev_put(isa);
>
> +			if ((id->device == 0x0415 || id->device == 0x3164)&&
> +			      (config->id != id->device))
> +				continue;
> +

applied


