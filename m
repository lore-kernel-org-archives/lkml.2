Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1C2PGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:06:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34525 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1C2PGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i/bg1i0DSg9k9RxpWF0OdpEsDk+igd4L4k7qRUbPNdOPA6g47Y9i2cjlJIQqXgjVGe
         3TPXpEziDRmq5e8r67CmB5VS0pNBkFcmhpGYXl9JjNXf1hjjeiKaftvxKM4C1Z9YzQbl
         O6/dqtEAWq8gJZLtI+4GdgbYO7gGFUmu3tXGw=
Subject: Re: [PATCH] ubifs: fix kconfig dependency warning
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Adrian Hunter <adrian.hunter@nokia.com>
In-Reply-To: <4D91F432.2070406@oracle.com>
References: <20110328134016.deb5d0c8.randy.dunlap@oracle.com>
	 <1301382178.2816.69.camel@localhost>  <4D91F432.2070406@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 18:04:15 +0300
Message-ID: <1301411055.21445.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 08:01 -0700, Randy Dunlap wrote:
> On 03/29/11 00:02, Artem Bityutskiy wrote:
> > On Mon, 2011-03-28 at 13:40 -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> Fix another kconfig dependency warning, this time in ubifs.
> >>
> >> warning: (UBIFS_FS_DEBUG && LOCKDEP && LATENCYTOP) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
> >>
> >> Without this patch, we can have:
> >> # CONFIG_KALLSYMS is not set
> >> CONFIG_KALLSYMS_ALL=y
> >> which is useless (does nothing unless KALLSYMS is enabled).
> >>
> >> However, ubifs builds successfully with or without this patch,
> >> and it builds with this line completely deleted,
> >> so what was this 'select' for?  Just developer convenience?
> > 
> > Well, here is the idea. You can compile UBIFS with debugging and without
> > debugging. Without debugging the resulting ubifs.ko is much smaller, so
> > some embedded people prefer it this way.
> > 
> > If you select debugging support, then we'll compile it a lot of
> > assertions, self-checks, test-modes, extra error messages with detailed
> > dumps. And we want to see stackdumps when errors or problems happen,
> > this is why we select KALLSYMS_ALL.
> > 
> > So I guess instead we should do:
> > 
> > select KALLSYMS
> > select KALLSYMS_ALL
> 
> Yes, that should do it.  Thanks for the explanation.

Will you submit a patch? Alternatively, I can make it myself. What is
your preference?

And I'll merge it upstream this cycle (before 2.6.39) then.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

