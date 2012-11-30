Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab2K3Qr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:47:58 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:59993 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758649Ab2K3Qr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:47:56 -0500
Date: Fri, 30 Nov 2012 08:47:46 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Message-ID: <1481496655.36482563.1354294066563.JavaMail.root@vmware.com>
In-Reply-To: <20121127002357.GA27683@core.coreip.homeip.net>
Subject: Re: [PATCH 12/12] VMCI: Some header and config files.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC23 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't get the resend either, so it seems our corporate mail really is
eating messages.  Lovely.

> > > +#define IOCTLCMD(_cmd) IOCTL_VMCI_ ## _cmd
> > 
> > I don't recall ever getting a valid answer for this (if you did, my
> > appologies, can you repeat it).  What in the world are you talking
> > about here?  Why is your driver somehow special from the thousands
> > of other ones that use the in-kernel IO macros properly for an
> > ioctl?

Because we're morons.  And unfortunately, we've shipped our product
using those broken definitions: our VMX uses them to talk to the driver.
So here's what we'd like to do.  We will send out a patch soon that
fixes the other issues you mention and also adds IOCTL definitions the
proper way using _IOBLAH().  But we'd also like to retain these broken
definitions for a short period, commented as such, at least until we
can get out a patch release to Workstation 9, at which point we can
remove them.  Does that sound reasonable?

Thanks!
- Andy
