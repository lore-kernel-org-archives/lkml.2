Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0EKQKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:10:25 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:55629 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0EKQKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:10:23 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 12:10:22 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MxNEfygtL0N6Pjj9lX5wd+EOZrrImD7ufWf8hSrmFWuzDEQPSvLok62NL1m95PYIA/
         31Jb8cD/ItTGrZAanLOzeZaZ7KahXAjJlCSdegyDqZGaswrOU5XfD1ziOpuhudXz2QtR
         hkI6vgh/0r3qlQNqSOeRh01G/VRUWOwOhHkqY=
MIME-Version: 1.0
In-Reply-To: <20100511154108.11546.12066.stgit@muvarov>
References: <20100511154108.11546.12066.stgit@muvarov>
Date: Tue, 11 May 2010 18:02:21 +0200
Message-ID: <AANLkTinTprEzXRIFeJfu6TEvPqj24UBjrrZN3MtZD6LH@mail.gmail.com>
Subject: Re: [PATCH] [POWEPC] crashdump: do not fail on null pointer 
	dereferencing
From: Vitaly Wool <vitalywool@gmail.com>
To: Maxim Uvarov <muvarov@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       uvarov@dev.rtsoft.ru
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
> index 6f4613d..341d8af 100644
> --- a/arch/powerpc/kernel/crash.c
> +++ b/arch/powerpc/kernel/crash.c
> @@ -375,6 +375,9 @@ void default_machine_crash_shutdown(struct pt_regs *regs)
>        for_each_irq(i) {
>                struct irq_desc *desc = irq_to_desc(i);
>
> +               if (!desc || !desc->chip || !desc->chip->eoi)
> +                       continue;
> +

Kinda unlikely that desc can be NULL here :)

~Vitaly
