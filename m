Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1ATTBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:01:49 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45779 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1ATTBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:01:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q7W6+XMjcZ01vxxKaiO0IgVM15sPHmcdE1rFFX4qxBl83n2kPfwy3qYWXcHCoZ5Eyt
         5IoBPtYjxah5vq3UEG3z7WtyFobvyDZ2Slpf0apcK/Z1wLhvPOKgsNrJ7OKUfxtAuxX6
         mIa/F2NLXN4Rqkoq40pd5i6u57KWxI1fXRfkk=
MIME-Version: 1.0
In-Reply-To: <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
	<1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
Date: Thu, 20 Jan 2011 20:01:47 +0100
Message-ID: <AANLkTimFcEC0oXJGnJ7HQKLB9thfuWHeWSYSMCGR=hWJ@mail.gmail.com>
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, joe@perches.com,
        dilinger@queued.net, Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/20 Po-Yu Chuang <ratbert.chuang@gmail.com>:
[...]
> +/******************************************************************************
> + * internal functions (receive descriptor)
> + *****************************************************************************/
> +static bool ftmac100_rxdes_first_segment(struct ftmac100_rxdes *rxdes)
> +{
> +       return le32_to_cpu(rxdes->rxdes0) & FTMAC100_RXDES0_FRS;
> +}
> +
> +static bool ftmac100_rxdes_last_segment(struct ftmac100_rxdes *rxdes)
> +{
> +       return le32_to_cpu(rxdes->rxdes0) & FTMAC100_RXDES0_LRS;
> +}
> +
[...]

You can change these and similar functions to use:

rxdes->rxdes0 & cpu_to_le32(FTMAC100_RXDES0_LRS)

This will be subject to constant folding by compiler and produce
better code for big-endian arches.

Best Regards,
Micha³ Miros³aw
