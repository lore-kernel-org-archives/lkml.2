Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab2CNXPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:15:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab2CNXPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:15:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Thu, 15 Mar 2012 00:19:22 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <4F60EFBB.5050703@codeaurora.org> <201203150004.17076.rjw@sisk.pl>
In-Reply-To: <201203150004.17076.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203150019.22379.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2012, Rafael J. Wysocki wrote:
> On Wednesday, March 14, 2012, Stephen Boyd wrote:
> > On 03/13/12 13:14, Rafael J. Wysocki wrote:
> > > All of those use cases are in fact of the "wait for user space to be thawed
> > > and then load the firmware" type, which I believe may be handled without
> > > changing that code.
> > >
> > > Why don't you make your kthread freezable, for one example?
> > >
> > > Why don't you use a freezable workqueue instead?
> > >
> > 
> > If we put it on the freezable workqueue or make it a freezable thread
> > will it work?
> 
> That depends on what exactly you want to achieve, which isn't entirely clear
> to me at this point.
> 
> > In my scenario a wakeup interrupt comes in that wakes us up from
> > suspend. Within that wakeup handler a work item is scheduled to the
> > freezable workqueue. That work item then calls request_firmware().
> 
> That should work.

I would consider using suspend/resume notifiers, however.

Thanks,
Rafael
