Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1FSTna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 15:43:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59374 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab1FSTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 15:43:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 16/19] OpenRISC: Headers
Date: Sun, 19 Jun 2011 21:43:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1308483825-6023-1-git-send-email-jonas@southpole.se> <1308483825-6023-17-git-send-email-jonas@southpole.se> <201106192139.45218.arnd@arndb.de>
In-Reply-To: <201106192139.45218.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192143.08208.arnd@arndb.de>
X-Provags-ID: V02:K0:7neX6aS+tANl3fQ2reC0kJkFfrP7EyW5cVZzpNjgrgI
 GGyhZO+03qDlaxm6NfACvID1uN5Pifi8fYIqnr2she6MzJyHiS
 r9ZSdOa7bWnA5PB0n2I4k6yhEMUmRc5eSUXq+fFnRZEVa+bZ6d
 unj9OYq6Bq6AxD/TR9fHlo2v+ukM/ZRAaHm/nex2XtYh4zDvM7
 7ZAdUJOJ2YKRimdiaS9+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 21:39:45 Arnd Bergmann wrote:
> > +
> > +extern inline void __delay(int loops)
> > +{
> > +     __asm__ __volatile__ (
> > +                           "l.srli %0,%0,1;"
> > +                           "1: l.sfeqi %0,0;"
> > +                           "l.bnf 1b;"
> > +                           "l.addi %0,%0,-1;"
> > +                           : "=r" (loops): "0" (loops));
> > +}
> > +
> 
> If you have an accurate high-resolution time source, better make this compare
> the current time in a loop than do a handcoded delay.

Hmm, I just saw that you actually have a better version of this, but
since this is marked "extern inline", code probably always gets this
version. Better never use extern inline, except when you have a good
reason and document it.

	Arnd
