Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2DCKmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 06:42:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39380 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2DCKmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 06:42:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204031228470.4560@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
 <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>
 <1330531826.3545.128.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
 <1332511796.18717.72.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net>
 <1332521515.22278.2.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203252302310.5527@eristoteles.iwoars.net>
 <alpine.DEB.2.00.1203252325100.5527@eristoteles.iwoars.net>
 <1332837188.31549.14.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203291639200.912@eristoteles.iwoars.net>
 <1333377383.22146.14.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1204021645070.29393@eristoteles.iwoars.net>
 <1333378674.22146.18.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1204031228470.4560@eristoteles.iwoars.net>
From: Guillaume LECERF <glecerf@gmail.com>
Date: Tue, 3 Apr 2012 12:41:42 +0200
X-Google-Sender-Auth: tRfXocJrK-XmRF1ImhULxqyxCOw
Message-ID: <CAJpamw7rXn_tLcFSE07AK4nrh9QXLBNzuehzLhB+rUbMv9UePA@mail.gmail.com>
Subject: Re: [patch] UBIFS: Add cryptographic functionality when a key is
 passed to the compress / decompress functions
To: Joel Reardon <joel@clambassador.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012/4/3 Joel Reardon <joel@clambassador.com>:
>  no_compr:
>        memcpy(out_buf, in_buf, in_len);
>        *out_len = in_len;
>        *compr_type = UBIFS_COMPR_NONE;
> +       goto encrypt;

This goto seems unneeded here.

> +
> +encrypt:
> +       if (crypto_key) {
> +               u8 iv[UBIFS_CRYPTO_KEYSIZE];
> +
> +               memset(iv, 0, UBIFS_CRYPTO_KEYSIZE);
> +               ubifs_aes_crypt(out_buf, *out_len, crypto_key, iv);
> +       }




-- 
Guillaume LECERF
OpenBricks developer - www.openbricks.org
