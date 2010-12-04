Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0LDBNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 20:13:12 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54119 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab0LDBNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 20:13:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=okQyIMtBFxkfwbnKoT5x1o68iN5NB49pYRoSshJEwoZ3n/lBUT6JWrcUkBIYs3Xp5P
         IVo93xpINA6uVGcnF71kcoswi/BVPb6waSWEsHqvrp7smX3UsKCaqgvQFvRfpzlttLYK
         oOhNPD9qARQOo/diCl0Gk2S7rD4YXdKKKrqKU=
MIME-Version: 1.0
In-Reply-To: <C0A2BC8065D6AE4BA759B25FE7A3795E036E7186@WHQBEMAIL1.whq.wistron>
References: <C0A2BC8065D6AE4BA759B25FE7A3795E036E7186@WHQBEMAIL1.whq.wistron>
Date: Fri, 3 Dec 2010 17:13:10 -0800
X-Google-Sender-Auth: gLizonp3Zn5MREqRdq0smHEhc4M
Message-ID: <AANLkTimx0U8-fAyDnnaFrUJfQMfEtcpYPymYbnBtEYK1@mail.gmail.com>
Subject: Re: [PATCH] intel_mid_dma: Fix section mismatch warnings
From: Dan Williams <dan.j.williams@intel.com>
To: Major_Lee@wistron.com
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 12:24 AM,  <Major_Lee@wistron.com> wrote:
> Fix the following section mismatch warnings.

Actually no, this patch does not fix the warnings, it hides them by
undoing the annotation.

Take a closer look at the warning message:

>
> WARNING: drivers/built-in.o(.data+0xfa10): Section mismatch in reference
> from the variable intel_mid_dma_pci to the function
> .devinit.text:intel_mid_dma_probe()
> The variable intel_mid_dma_pci references the function __devinit
> intel_mid_dma_probe() If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the
> variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
> *_console,

Let me highlight the relevant suggestion:

> or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
> *_console,

...nowhere does it say delete the __devinit annotation.

--
Dan
