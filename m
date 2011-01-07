Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1AGPoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:44:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab1AGPoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:44:12 -0500
Subject: Re: [-next] ERROR: "strchr" [drivers/target/target_core_mod.ko]
 undefined!
From: James Bottomley <James.Bottomley@suse.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinhrj38rbEt7ds971D9g-UF+xS0jmzO7X15ZaLn@mail.gmail.com>
References: <AANLkTinhrj38rbEt7ds971D9g-UF+xS0jmzO7X15ZaLn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 09:44:04 -0600
Message-ID: <1294415045.4895.16.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 11:57 +0100, Geert Uytterhoeven wrote:
> Since a few days, linux-next shows:
> 
> | ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!
> 
> in m68k allmodconfig builds
> (http://kisskb.ellerman.id.au/kisskb/buildresult/3754323/).
> 
> I guess this is caused by the following 3 calls to strstr():
> 
> drivers/target/target_core_configfs.c:
> +       ptr = strstr(page, "1");
> 
> +       str = strstr(buf, "_");
> 
> +       str2 = strstr(str+1, "_");
> 
> Some versions of gcc replace calls to strstr() with single-character
> "needle" string parameters by calls to strchr() behind our back.
> This causes linking errors if strchr() is defined as an inline function
> in <asm/string.h> (e.g. on m68k).
> 
> You can prevent this by explicitly calling strchr() instead.
> 
> Cfr. commit 59d309f9c8ef0bd01bf93cc0e758f1d810417bdb
> ("kgdb: Replace strstr() by strchr() for single-character needles).
> 
> Gr{oetje,eeting}s,

Surely the fix for this is not to inline it in m68k? If gcc is growing
the capability to make these types of transformations, it's not going to
stop at single entry string strstr().

If you want to keep the fast inline, there is a way (which I forget) to
drop an external reference as well, just in case.

James


