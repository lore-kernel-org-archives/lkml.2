Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0JOUEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:04:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab0JOUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:04:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 04/14] arch/tile: change lower bound on syscall error return to -4095
Date: Fri, 15 Oct 2010 22:03:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1287090280.git.cmetcalf@tilera.com> <201010142322.20850.arnd@arndb.de> <4CB88C9F.7040109@tilera.com>
In-Reply-To: <4CB88C9F.7040109@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010152203.54665.arnd@arndb.de>
X-Provags-ID: V02:K0:BaIHCo8Z7dSHTF8E8lVtPbBhwfrGrXL9CfhAkmbAWYX
 SMVVUM+8iUXaiqCA+ljoUYAUpD52ezTwifcg9p3ZLpCypqNQz0
 6WpLbTxSvScw/lLFBmBDT2Irl48VQGisyVaWOkJaHK36dVWMvY
 ZBLrdul6HViW57+MsYw1FPKPy88iyhk0G8R3sAI9OYwoE+NiPM
 acM6kRU0jbL2Z9HdUIqDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010 19:17:19 Chris Metcalf wrote:
>  On 10/14/2010 5:22 PM, Arnd Bergmann wrote:
> > On Thursday 14 October 2010 21:14:29 Chris Metcalf wrote:
> >> Previously we were using -1023, which is fine for normal syscall
> >> error returns, but the common value in use for other platforms
> >> is -4095, and one Tilera-specific driver does use values in the
> >> -1100 range, so tickled this bug.
> > The patch is ok, but note that any value above starting at 512 is meant
> > as kernel internal, so funny things may happen if a driver goes
> > beyond that for errors returned to the user.
> >
> > Better use just the predefined error codes if possible.
> 
> Thanks, good point.  In practice we've found that for the syscalls we use
> (e.g. pwrite) that are intended to return errors codes from our drivers the
> errors are in fact properly returned.  But I've filed a bug internally that
> we should review our usage of error codes and determine if there are more
> standard ways to handle this, e.g. return a Linux errno but allow passing a
> pointer to store a more specific hypervisor or driver error code in.

I think in general I'd do something like return -EIO with a hardware or
hypervisor result code written to memory if that happens. In specific
drivers there may of course be a better way.

	Arnd
