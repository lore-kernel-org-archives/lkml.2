Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1AGVKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:10:35 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:49176 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1AGVKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:10:33 -0500
Subject: Re: [-next] ERROR: "strchr" [drivers/target/target_core_mod.ko]
	undefined!
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1294415045.4895.16.camel@mulgrave.site>
References: <AANLkTinhrj38rbEt7ds971D9g-UF+xS0jmzO7X15ZaLn@mail.gmail.com>
	 <1294415045.4895.16.camel@mulgrave.site>
Content-Type: text/plain
Date: Fri, 07 Jan 2011 13:04:34 -0800
Message-Id: <1294434274.2895.146.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 09:44 -0600, James Bottomley wrote:
> On Fri, 2011-01-07 at 11:57 +0100, Geert Uytterhoeven wrote:
> > Since a few days, linux-next shows:
> > 
> > | ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!
> > 
> > in m68k allmodconfig builds
> > (http://kisskb.ellerman.id.au/kisskb/buildresult/3754323/).
> > 
> > I guess this is caused by the following 3 calls to strstr():
> > 
> > drivers/target/target_core_configfs.c:
> > +       ptr = strstr(page, "1");
> > 
> > +       str = strstr(buf, "_");
> > 
> > +       str2 = strstr(str+1, "_");
> > 
> > Some versions of gcc replace calls to strstr() with single-character
> > "needle" string parameters by calls to strchr() behind our back.
> > This causes linking errors if strchr() is defined as an inline function
> > in <asm/string.h> (e.g. on m68k).
> > 
> > You can prevent this by explicitly calling strchr() instead.
> > 
> > Cfr. commit 59d309f9c8ef0bd01bf93cc0e758f1d810417bdb
> > ("kgdb: Replace strstr() by strchr() for single-character needles).
> > 
> > Gr{oetje,eeting}s,
> 
> Surely the fix for this is not to inline it in m68k? If gcc is growing
> the capability to make these types of transformations, it's not going to
> stop at single entry string strstr().
> 
> If you want to keep the fast inline, there is a way (which I forget) to
> drop an external reference as well, just in case.
> 

Hi guys,

So I really don't have a strong perference here, but would tend to agree
with James that this should probably be fixed in m68k..  If this is too
much of an pain for you Geert I am happy to make this change.

Thanks!

--nab

