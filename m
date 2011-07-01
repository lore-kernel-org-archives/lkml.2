Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1GAUFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 16:05:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48647 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab1GAUFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 16:05:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/10 v6] PM / Domains: Don't stop wakeup devices during system sleep transitions
Date: Fri, 1 Jul 2011 22:06:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <Pine.LNX.4.44L0.1107011043410.1988-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1107011043410.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107012206.42475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 01, 2011, Alan Stern wrote:
> On Fri, 1 Jul 2011, Rafael J. Wysocki wrote:
> 
> > So the only way forward I can see is to add a special PM domain callback,
> > say .active_wakeup(), that will return "true" if the device is to be left
> > active if wakeup-enabled.  So the check you don't like will become
> > something like:
> > 
> > if (device_may_wakeup(dev) && genpd->active_wakeup
> >     && genpd->active_wakeup(dev))
> >         return 0;
> > 
> > Would that be better?
> 
> Another option, less flexible but perhaps easier to use, would be to 
> set a couple of bitflags indicating whether the device needs power or 
> clocks to handle wakeup signals.

Well, I agree, but I've decided to add the new callback after all.

Thanks,
Rafael
