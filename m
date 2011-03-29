Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1C2TjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:39:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53186 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab1C2TjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:39:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH] PM / Hibernate: Introduce CONFIG_HIBERNATE_INTERFACE
Date: Tue, 29 Mar 2011 21:39:35 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        Shriram Rajagopalan <rshriram@cs.ubc.ca>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201103261229.44770.rjw@sisk.pl> <1301414013.18413.29.camel@zakaz.uk.xensource.com>
In-Reply-To: <1301414013.18413.29.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103292139.35645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 29, 2011, Ian Campbell wrote:
> Hi Rafael,
> 
> On Sat, 2011-03-26 at 11:29 +0000, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Xen save/restore is going to use hibernate device callbacks for
> > quiescing devices and putting them back to normal operations and it
> > would need to select CONFIG_HIBERNATION for this purpose.  However,
> > that also would cause the hibernate interfaces for user space to be
> > enabled, which might confuse user space, because the Xen kernels
> > don't support hibernation.  Moreover, it would be wasteful, as it
> > would make the Xen kernels include a substantial amount of code that
> > they would never use.
> > 
> > To address this issue introduce new power management Kconfig option
> > CONFIG_HIBERNATE_INTERFACE, such that the hibernate interfaces for
> > user space and the image-handling code will depend on it and it will
> > select CONFIG_HIBERNATION.  Then, Xen save/restore will be able to
> > select CONFIG_HIBERNATION without dragging the entire hibernate code
> > along with it.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Were you planning to put this forward for 2.6.39 or are you waiting for
> 2.6.40?

I'm goint to push it for 2.6.39.  In fact, I'm going to send the pull request
shortly.

Thanks,
Rafael
