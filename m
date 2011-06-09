Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1FIF0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 01:26:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42922 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1FIF0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 01:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=ffXKRnR/5a1yRcImoNhQcqr5chnsL2vmWXT43BI0/oODMimlnqiODAeha9kErukEnf
         pamzLsgTZoeAvJVA/GnS83QRzP6BNN5P8XjgJG5cAQqJxQIdxpMhdkJnQJr9XbjFvdyZ
         N3QIhcrJ9NFBxXN2q8sm9RDNi/e/W0uJLFSDo=
Date: Thu, 9 Jun 2011 13:25:17 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Connor Hansen <cmdkhh@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        randy.dunlap@oracle.com, greg@kroah.com, joe@perches.com
Subject: Re: [PATCH RESEND]Remove a warning for drivers/edac/i82975x_edac.c
Message-ID: <20110609052509.GA3997@gmail.com>
Mail-Followup-To: Connor Hansen <cmdkhh@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	randy.dunlap@oracle.com, greg@kroah.com, joe@perches.com
References: <20110609030401.GA2615@gmail.com>
 <BANLkTim_=2kWXAzkECC4A3t9uxGERwBU7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTim_=2kWXAzkECC4A3t9uxGERwBU7g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 09:26:46PM -0700, Connor Hansen wrote:
> When I compile 3.0.0-rc2+ I don't get this warning.
> please make sure this issue still exists.
I have not compiled 3.0.0-rc2+, but
i fetch portions of drivers/edac/i82975x_edac.c
of 3.0.0-rc2+ like below.

[...]
296         page = (unsigned long) info->eap;
297         if (info->xeap & 1)
298                 page |= 0x100000000ul;
299         chan = page & 1;
300         page >>= 1;
[...]

The following codes prove this warning
remians.

#include <stdio.h>

int main(void)
{
	unsigned long a;

	a = 0x100000000ul;
	printf("%lu\n", a);
	return 0;
}

jiawei@jiawei-laptop:~/GTK$ gcc 5.c -Wall -o 1
5.c: In function ‘main’:
5.c:7: warning: integer constant is too large for ‘unsigned long’ type
5.c:7: warning: large integer implicitly truncated to unsigned type

But if you program it like below, it is well for us.

#include <stdio.h>

int main(void)
{
	unsigned long long a;

	a = 0x100000000ull;
	printf("%llu\n", a);
	return 0;
}

Thanks
Harry Wei
> Connor
> 
> On Wed, Jun 8, 2011 at 8:04 PM, Harry Wei <jiaweiwei.xiyou@gmail.com> wrote:
> > From: Harry Wei <harryxiyou@gmail.com>
> >
> > When i compile 2.6.39.1, a warning shows like below.
> > This patch can fix the warning. And i works well with
> > my PC.
> >
> > [...]
> > CC [M] ??drivers/edac/e752x_edac.o
> > CC [M] ??drivers/edac/i82875p_edac.o
> > CC [M] ??drivers/edac/i82975x_edac.o
> > drivers/edac/i82975x_edac.c: In function ?????????i82975x_process_error_info?????????:
> > drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for ?????????unsigned long????????? type
> > CC [M] ??drivers/edac/i3000_edac.o
> > CC [M] ??drivers/edac/i3200_edac.o
> > CC [M] ??drivers/edac/x38_edac.o
> > CC [M] ??drivers/edac/i82860_edac.o
> > [...]
> >
> >
> > Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> > Index: prj/drivers/edac/i82975x_edac.c
> > ===================================================================
> > --- prj.orig/drivers/edac/i82975x_edac.c ?? ?? ?? ??2011-06-04 10:09:55.351174516 +0800
> > +++ prj/drivers/edac/i82975x_edac.c ?? ?? 2011-06-04 10:10:30.875168437 +0800
> > @@ -293,9 +293,9 @@
> > ?? ?? ?? ?? ?? ?? ?? ??info->errsts = info->errsts2;
> > ?? ?? ?? ??}
> >
> > - ?? ?? ?? page = (unsigned long) info->eap;
> > + ?? ?? ?? page = (unsigned long long) info->eap;
> > ?? ?? ?? ??if (info->xeap & 1)
> > - ?? ?? ?? ?? ?? ?? ?? page |= 0x100000000ul;
> > + ?? ?? ?? ?? ?? ?? ?? page |= 0x100000000ull;
> > ?? ?? ?? ??chan = page & 1;
> > ?? ?? ?? ??page >>= 1;
> > ?? ?? ?? ??offst = page & ((1 << PAGE_SHIFT) - 1);
> > --
