Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1BKKDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:03:09 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53872 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab1BKKDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:03:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=tRMcY2hrnVaXr3VVa+cH/HgaonvvpJeUX9Q+tp+Ssh9DeV/RPp5+0jDFqfolfnlfSq
         v7/Y4SI/PFoFOzS06X3J1ipa/vELG0C0+QCLu1j0ZUUxk8DPEzBlPk09DoIL0/qxm/cc
         ulVHZOQ2uuT3VaoZNfjDZ8alMJxo//VVvk6Oo=
MIME-Version: 1.0
In-Reply-To: <1297418437-23553-1-git-send-email-antony@niisi.msk.ru>
References: <1297418437-23553-1-git-send-email-antony@niisi.msk.ru>
From: Guillaume LECERF <glecerf@gmail.com>
Date: Fri, 11 Feb 2011 11:02:46 +0100
X-Google-Sender-Auth: Wu4Nf4duJF_cj8L7mf-AcWyzH8o
Message-ID: <AANLkTik_KdzX-3CTyE1CxyOauHgd5p75VApuTX7DGZn1@mail.gmail.com>
Subject: Re: [PATCH] mtd: jedec_probe: initialise make sector erase command variable
To: Antony Pavlov <antony@niisi.msk.ru>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

2011/2/11 Antony Pavlov <antony@niisi.msk.ru>:
> In the commit 08968041bef437ec363623cd3218c2b083537ada
>  (mtd: cfi_cmdset_0002: make sector erase command variable)
> introdused a field sector_erase_cmd. In the same commit initialisation
> of cfi->sector_erase_cmd made in cfi_chip_setup()
> (file drivers/mtd/chips/cfi_probe.c), so the CFI chip has no problem:
>
> ...
>        cfi->cfi_mode = CFI_MODE_CFI;
>        cfi->sector_erase_cmd = CMD(0x30);
> ...
>
> But for the JEDEC chips this initialisation is not carried out,
> so the JEDEC chips have sector_erase_cmd == 0.
>
> It's not possible symply add the line
>        p_cfi->sector_erase_cmd = CMD(0x30);
> to the cfi_jedec_setup() function be cause CMD() macros needs
> map and cfi variables. So this patch makes necessary changes.
>
> Signed-off-by: Antony Pavlov <antony@niisi.msk.ru>

Acked-by: Guillaume LECERF <glecerf@gmail.com>

-- 
Guillaume LECERF
GeeXboX developer - www.geexbox.org
