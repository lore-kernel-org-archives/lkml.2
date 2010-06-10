Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718Ab0FJUOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:14:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46458 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0FJUOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=XjCSHjhdreqTsNXzxppv0vn5gQFFoc8T3ZhKKtihMRq2xo4Exdy5rfukl9i30/hSHF
         BosxyAsmVdEve84XZdjw9etm5KqYPUFh8DVg1osveQCxtiLdPHadJd0S/P/Kn7mbHOAq
         zNcjPRQbL5zO9MszBsUI9PZ3jISXbKqatg5EQ=
Message-ID: <4C1147AB.5050604@pobox.com>
Date: Thu, 10 Jun 2010 16:14:35 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Tejun Heo <tj@kernel.org>,
       Robert Hancock <hancockrwd@gmail.com>,
       Vivek Mahajan <vivek.mahajan@freescale.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] sata_sil24: memset() overflow
References: <20100609120153.GF5483@bicker>
In-Reply-To: <20100609120153.GF5483@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 08:01 AM, Dan Carpenter wrote:
> cb->atapi.cdb is an array of 16 u8 elements.  The call too memset()
> would set the first part of the sge array to zero as well.  It's not
> a packed struct.
>
> This one has been around for five years.  I found it with Smatch.  I
> think the reason no one has seen it before is because we normally call
> sil24_fill_sg() and that overwrites sge with proper information?
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>
> ---
> I don't have this hardware myself so I can't test it.  Sorry. :(
>
> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
> index e925051..9e459eb 100644
> --- a/drivers/ata/sata_sil24.c
> +++ b/drivers/ata/sata_sil24.c
> @@ -865,7 +865,7 @@ static void sil24_qc_prep(struct ata_queued_cmd *qc)
>   	} else {
>   		prb =&cb->atapi.prb;
>   		sge = cb->atapi.sge;
> -		memset(cb->atapi.cdb, 0, 32);
> +		memset(cb->atapi.cdb, 0, sizeof(cb->atapi.cdb));
>   		memcpy(cb->atapi.cdb, qc->cdb, qc->dev->cdb_len);

applied


