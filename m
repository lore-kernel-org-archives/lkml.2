Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab0I1JNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 05:13:04 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58878 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab0I1JND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 05:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Gj5kznOI1KLbfiBds+gojNe0ZSSV6GQMzG9KOm6WPKxe0i6hzgDUOhySA9eDcKcOTG
         A19lv4+m0sWdDmA7IxxdeXPxdrwYp4oxubx/wW47BzrPjfdY9F4TfGgvWU4iLYeKziLz
         PmPhrkDEVTP2GlpNyZaZnJv1T61rKZzdshD2I=
MIME-Version: 1.0
In-Reply-To: <201005152214.53993.sshtylyov@ru.mvista.com>
References: <201005152214.53993.sshtylyov@ru.mvista.com>
Date: Tue, 28 Sep 2010 11:13:02 +0200
Message-ID: <AANLkTinuQsSP1EHWn5DS_9PMrsgj+fpjLOOkpnnBaf8Q@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] ARM: add CPPI 4.1 DMA support
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        khilman@deeprootsystems.com, linux@arm.linux.org.uk,
        linux kernel <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/15 Sergei Shtylyov <sshtylyov@ru.mvista.com>:

> Add support for Texas Instuments Communication Port Programming Interface 4.1
> (CPPI 4.1) used on OMAP-L1x/DA8xx and AM35x.

Sorry for late feedback ...

> +++ linux-davinci/arch/arm/common/cppi41.c

Can you migrate this driver to drivers/dma/cppi41.c and use the
DMAengine interface like so many DMA drivers we have created
recently, or is there some very special characteristics about this
DMA controller meriting it to be placed in arch/arm/*?

Note: we have the support for PL08x found in ARM reference
designs queued for drivers/dma/amba-pl08x.c,
not arch/arm/common/*.

The rationale about this is to lower the churn in arch/arm/*
and put drivers into the proper subsystems, and in this case
there is an appropriate subsystem to be used.

Yours,
Linus Walleij
