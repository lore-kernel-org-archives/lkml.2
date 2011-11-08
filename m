Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1KHJfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:35:05 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:44261 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab1KHJfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:35:03 -0500
Subject: Re: [PATCH] [TRIVIAL] 8250_hp300: Fix warning typo 'CONFIG_8250'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <alpine.LNX.2.00.1111081025470.1964@pobox.suse.cz>
References: <1320673476.14409.367.camel@x61.thuisdomein>
	 <alpine.LNX.2.00.1111081025470.1964@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 10:34:47 +0100
Message-ID: <1320744887.14409.379.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 10:26 +0100, Jiri Kosina wrote:
> On Mon, 7 Nov 2011, Paul Bolle wrote:
> > 1) If SERIAL_8250_HP300 is set but neither HPDCA nor HPAPCI are set we
> > end up with an elaborate nop, don't we? Initialization should always
> > fail in that case. So effectively SERIAL_8250_HP300 depends on HPDCA
> > and/or HPAPCI. Was there perhaps some problem in translating that
> > dependency into a Kconfig dependency?

[...]

> > --- a/drivers/tty/serial/8250_hp300.c
> > +++ b/drivers/tty/serial/8250_hp300.c
> > @@ -21,7 +21,7 @@
> >  #include "8250.h"
> >  
> >  #if !defined(CONFIG_HPDCA) && !defined(CONFIG_HPAPCI)
> > -#warning CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?
> > +#warning CONFIG_SERIAL_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure?
> >  #endif
> 
> What is the point of this warning anyway? Shouldn't everything necessary 
> be taken care of by Kconfig rules?

That's exactly what I'm trying to find out with my questions (aimed at
the m68k people, see 1) above).


Paul Bolle

