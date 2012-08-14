Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2HNJnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:43:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2HNJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:43:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Date: Tue, 14 Aug 2012 09:42:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, broonie@opensource.wolfsonmicro.com,
        Samuel Ortiz <sameo@linux.intel.com>
References: <1344527635-6163-1-git-send-email-lee.jones@linaro.org> <1344527635-6163-6-git-send-email-lee.jones@linaro.org> <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
In-Reply-To: <CACRpkdZ7bMBytyDppV2sB1d1sUbDpPRqAQVOq8k4UOYdmg+Mkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208140942.54773.arnd@arndb.de>
X-Provags-ID: V02:K0:UIVU/bLPxwqh88pVMcU2sNDNSDC9nuTWtRRXdfRuBfm
 iqXbvJhj+6bdUg2AxqXxKoUgkt2TF+kx8xRZdt9eV+GUSqAH4T
 6uErWihQTBsoz/k/EES9/5fHiWMmBRBZ+A1PIjuUEQqihO58SG
 T0OAz+uKr/LLmx/UEtYXJiY0EbtjJUSL5NQhpB2mvEeYE/XxM2
 HWuQ+paGqoeegMPZWnQ+G3jhklfjTNvMLbIrBnbWcaYL66eu7h
 pjib9lr6Vkcl+tgW7pS6to+clXsZ7fpniIS2OcTRVCm3ZCP4aJ
 Wy5pZ6X6WQzllQ1B+sXZsfVc6d+b5MHTpWRsl2w6d5/A907SzS
 wCrNMBdWSjwp6Pd+/mfs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Linus Walleij wrote:
> 
> On Thu, Aug 9, 2012 at 5:53 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > +static struct irq_domain *db8500_irq_domain;
> 
> So this is a good idea.
> 
> > +int db8500_irq_get_virq(int irq);
> 
> And I'm sceptic about this business. Why isn't this physical-to virtual
> mapping business confined to the core MFD driver? But enlighten me.
> 

I believe MFD does not (yet) know about IRQ domains. The wm8994
and 88pm80x drivers do this slightly different by exporting
a foo_request_irq() function that performs the mapping.

Traditionally, an MFD would add an offset to the local IRQ number
to put the VIRQ into the IRQ resource, but this doesn't work when
you have domains other than legacy.

	Arnd
