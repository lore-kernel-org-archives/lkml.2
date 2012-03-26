Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2CZUdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:33:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab2CZUdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:33:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/6] firmware_class: Fix problems with usermodehelper test
Date: Mon, 26 Mar 2012 22:37:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203260000.34377.rjw@sisk.pl> <20120326184217.GC29332@kroah.com>
In-Reply-To: <20120326184217.GC29332@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203262237.49735.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 26, 2012, Greg KH wrote:
> On Mon, Mar 26, 2012 at 12:00:34AM +0200, Rafael J. Wysocki wrote:
> > Hi all,
> > 
> > The following series of patches fixes two problems with
> > request_firmware() and request_firmware_nowait() resulting from commit
> > a144c6a6c924aa1da04dd77fb84b89927354fdff
> > 
> >     PM: Print a warning if firmware is requested when tasks are frozen
> > 
> > The first problem is that request_firmware_nowait() may fail if it happens
> > to run in parallel with system suspend.  It should't fail in such situations
> > and that is addressed by the first three patches (that code has been discussed
> > with Linus at al already).
> > 
> > The second issue is that request_firmware() may be called in a thread which
> > isn't related to system suspend and if suspend happens exactly at that time,
> > request_firmware() will fail (and print a scary warning), although it shouldn't.
> > This problem is addressed by the remaining three patches, which are new.
> 
> At first glance, they all look good to me, thanks for doing this work:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!

> I'm guessing this will go in through one of your trees, right?

That's correct.

Thanks,
Rafael
