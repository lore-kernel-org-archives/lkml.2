Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab2EPMJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:09:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58990 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab2EPMJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:09:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
Date: Wed, 16 May 2012 12:09:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, linus.walleij@stericsson.com, linux-sh@vger.kernel.org,
        horms@verge.net.au, grant.likely@secretlab.ca, olof@lixom.net
References: <20120515154333.6659.66479.sendpatchset@w520> <20120516072927.GN7988@linux-sh.org> <CANqRtoSSEb9jwEmvbhBuyHp-9BfUSRabQzqjrrVGTFDP-AHutQ@mail.gmail.com>
In-Reply-To: <CANqRtoSSEb9jwEmvbhBuyHp-9BfUSRabQzqjrrVGTFDP-AHutQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205161209.03985.arnd@arndb.de>
X-Provags-ID: V02:K0:h4DS8oY3V8s6caVuczyaZgqV9LsMvxGNuQEVo+o+7yY
 2gKFUxXx2J8xEsP1KHwjQgl2MSbiGZlN+wmk+IEbV1+p8NtED5
 lK17XeOI54m8u736W6KsRb4PIxTh6my4kyfbziOwLO+77XW6z3
 IADOGwr/MeSQbLEoOpLUYt75Q8VSxk7HYufqF1M7I0Bl9Qb0iM
 7HfAkaVtyXcCqdJs5QKlisH1i+S2NkSi6jpIoTBMdJF5nZtJ/T
 QM354CkPSbRYSLLndLsvd2ZL63zplpYmxEsKt58lYyuDk5fvMd
 mWiMwTo4ucsTPJCiDWXcbfp6Fpcv3zjGcuck38bWWcvhko3YOn
 w54cufvQo+Xqj2vNvguY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2012, Magnus Damm wrote:
> > irq_domain_add_legacy() exists for existing static ranges, which there is
> > really no reason to be adding in new board/platform support. You don't
> > have to worry about virq overlap since irq_create_mapping() already wraps
> > on top of irq_alloc_desc_xxx() for lookup.
> 
> So I intentionally made use of the legacy domain in the non-DT case.
> This because I want to let the SoC code set the static IRQ ranges via
> platform data.

I think it's generally better to use just one code path for both cases,
if you need both DT and non-DT support, which means you would always
use irq_domain_add_legacy. Once you have the final patch to convert it
to DT, you can remove the legacy domain and just convert it to linear.

	Arnd
