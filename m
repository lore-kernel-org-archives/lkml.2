Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0JKNOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:14:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38694 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0JKNOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=wOEXDBhcilAsmMouAKSQwK24UTe1j7hje3A4Im78TZtnJu+uSzh3rgjCom6ImQsOwl
         q8EIzNQIsSILBM/r6UoRWxzF5wBx0kCXlvi1m1UodoZDNXLOMRZcQ5hfAS06ODcqQKRo
         3iJEg1Fnfh6P9hQvFNbS3OGsQGfw9hf5NqcVs=
MIME-Version: 1.0
In-Reply-To: <1286675743-7261-1-git-send-email-marek.vasut@gmail.com>
References: <1286675743-7261-1-git-send-email-marek.vasut@gmail.com>
From: Ian Molton <ian@mnementh.co.uk>
Date: Mon, 11 Oct 2010 14:14:29 +0100
X-Google-Sender-Auth: t18h794PxfrW5S_9kBKQ8ETD1zc
Message-ID: <AANLkTikxr3JUR3cBQFONbXqxnF_8pP-EtaYP=mLn2BiC@mail.gmail.com>
Subject: Re: [PATCH] Remove __devinitdata from tc6393xb_mmc_resources
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, axel.lin@gmail.com,
        hartleys@visionengravers.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ian Molton <ian@mnementh.co.uk>

-- 
Ian Molton
Linux, Automotive, and other hacking:
http://www.mnementh.co.uk/



On 10 October 2010 02:55, Marek Vasut <marek.vasut@gmail.com> wrote:
> This static struct resource tc6393xb_mmc_resources[] is used in resume function,
> therefore the data can not be wiped after init.
>
> Also, this causes a section mismatch.
>
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
>  drivers/mfd/tc6393xb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> index ef6c42c..1ea80d8 100644
> --- a/drivers/mfd/tc6393xb.c
> +++ b/drivers/mfd/tc6393xb.c
> @@ -155,7 +155,7 @@ static struct resource __devinitdata tc6393xb_nand_resources[] = {
>        },
>  };
>
> -static struct resource __devinitdata tc6393xb_mmc_resources[] = {
> +static struct resource tc6393xb_mmc_resources[] = {
>        {
>                .start  = 0x800,
>                .end    = 0x9ff,
> --
> 1.7.1
>
>
