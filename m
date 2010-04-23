Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0DWBwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:52:50 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:56250 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0DWBwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GMOKL3TNZpRnLMrii0iU4gOtjUsoNlhL1db7yQezcbfYqasbYVow0yYeJO1WQmSCNa
         3gzLdx4x6BcQ2DmhO89UQfDGnKjpzPSH3gRDRs/sxEoqcHsx418W2eqmr9EOiCgjVtQ/
         tqJUOMU4kDdnxdHyjzkxIoY3+A9B7eUYqQSoU=
Message-ID: <4BD0FD68.90408@garzik.org>
Date: Thu, 22 Apr 2010 21:52:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
CC: linux@dominikbrodowski.net,
       "linux-pcmcia@lists.infradead.org" <linux-pcmcia@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH - update pata_pcmcia/ide-cs with transcend and kingston
 cards
References: <20100419195411.f16d8f68.kristoffer.ericson@gmail.com>
In-Reply-To: <20100419195411.f16d8f68.kristoffer.ericson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 01:54 PM, Kristoffer Ericson wrote:
> This patch adds idstrings for Kingston 1GB/4GB and Transcend 4GB/8GB.
>
> Signed-off-by: Kristoffer Ericson<kristoffer.ericson@gmail.com>
>
> diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
> index ab87e4f..defce28 100644
> --- a/drivers/ide/ide-cs.c
> +++ b/drivers/ide/ide-cs.c
> @@ -409,6 +409,8 @@ static struct pcmcia_device_id ide_ids[] = {
>   	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
>   	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
>   	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
> +	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x3e520e17),
> +	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 4GB", 0x2e6d1829, 0x531e7d10),
>   	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
>   	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
>   	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
> @@ -429,6 +431,8 @@ static struct pcmcia_device_id ide_ids[] = {
>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x9351e59d),
> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS8GCF133", 0x709b1bf1, 0xb2f89b47),
>   	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
>   	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
>   	PCMCIA_DEVICE_PROD_ID1("STI Flash", 0xe4a13209),
> diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
> index 3c3172d..4164dd2 100644
> --- a/drivers/ata/pata_pcmcia.c
> +++ b/drivers/ata/pata_pcmcia.c
> @@ -424,6 +424,8 @@ static struct pcmcia_device_id pcmcia_devices[] = {
>   	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
>   	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
>   	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
> +	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x3e520e17),
> +	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 4GB", 0x2e6d1829, 0x531e7d10),
>   	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
>   	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
>   	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
> @@ -444,6 +446,8 @@ static struct pcmcia_device_id pcmcia_devices[] = {
>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
>   	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x9351e59d),
> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS8GCF133", 0x709b1bf1, 0xb2f89b47),
>   	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
>   	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
>   	PCMCIA_DEVICE_PROD_ID1("STI Flash", 0xe4a13209),
>
>

applied

