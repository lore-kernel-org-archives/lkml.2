Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1KQUNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:13:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44555 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab1KQUNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:13:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] PM Sleep: Don't extend wakeup paths to devices with ignore_children set
Date: Thu, 17 Nov 2011 21:16:07 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201111162321.58572.rjw@sisk.pl> <20111116235227.GB14252@suse.de>
In-Reply-To: <20111116235227.GB14252@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111172116.07326.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 17, 2011, Greg KH wrote:
> On Wed, Nov 16, 2011 at 11:21:58PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Commit 4ca46ff3e0d8c234cb40ebb6457653b59584426c (PM / Sleep: Mark
> > devices involved in wakeup signaling during suspend) introduced
> > the power.wakeup_path field in struct dev_pm_info to mark devices
> > whose children are enabled to wake up the system from sleep states,
> > so that power domains containing the parents that provide their
> > children with wakeup power and/or relay their wakeup signals are not
> > turned off.  Unfortunately, that introduced a PM regression on SH7372
> > whose power consumption in the system "memory sleep" state increased
> > as a result of it, because it prevented the power domain containing
> > the I2C controller from being turned off when some children of that
> > controller were enabled to wake up the system, although the
> > controller was not necessary for them to signal wakeup.
> > 
> > To fix this issue use the observation that devices whose
> > power.ignore_children flag is set for runtime PM should be treated
> > analogously during system suspend.  Namely, they shouldn't be
> > included in wakeup paths going through their children.  Since the
> > SH7372 I2C controller's power.ignore_children flag is set, doing so
> > will restore the previous behavior of that SOC.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks!
