Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0KYKs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:48:26 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38104 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0KYKsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=RMotp0mjyBm5iM74YjlmKo8HtaB/sGQH+OmY7CsFCXCu+qWlVdF7r9MIyZ/hNu2qQF
         f5LbQ2VMkDvm3xY/keHoB597w6XbH47d6uvaN37itZC4lhhpnUGvHH/3oIkpFw3YiAbo
         0QqSpnP01UIZAa0qOnvT+PFyMtAFmx+8ITiZo=
Date: Thu, 25 Nov 2010 13:48:17 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lin Mac <mkl0301@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: cns3xxx: Add architecture definition for
 EHCI/OHCI controller
Message-ID: <20101125104817.GA31779@oksana.dev.rtsoft.ru>
References: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
 <1290443565-20766-3-git-send-email-mkl0301@gmail.com>
 <20101124161122.GA15902@oksana.dev.rtsoft.ru>
 <AANLkTimMEALmH08RKQet_MGiyEFYpD2kVtPtmKJpmhtZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimMEALmH08RKQet_MGiyEFYpD2kVtPtmKJpmhtZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 03:25:38PM +0800, Lin Mac wrote:
[...]
> >  #include <linux/module.h>
> >  #include <linux/io.h>
> >  #include <linux/delay.h>
> > +#include <asm/atomic.h>
> It's not necessary for mach/pm.h already included it, right?

Technically, it's not necessary. But in Linux we don't rely on
headers including other headers. Think that someday mach/pm.h
may not include asm/atomic.h, so the build will break.

Thanks,

> 
> >  #include <mach/system.h>
> >  #include <mach/cns3xxx.h>
> >  #include <mach/pm.h>
> > @@ -117,3 +118,6 @@ int cns3xxx_cpu_clock(void)
> >        return cpu;
> >  }
> >  EXPORT_SYMBOL(cns3xxx_cpu_clock);
> > +
> > +atomic_t usb_pwr_ref = ATOMIC_INIT(0);
> > +EXPORT_SYMBOL(usb_pwr_ref);

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
