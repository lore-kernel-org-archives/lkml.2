Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1FZMXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 08:23:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58775 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466Ab1FZMVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 08:21:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system sleep
Date: Sun, 26 Jun 2011 14:22:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
References: <Pine.LNX.4.44L0.1106252235560.10907-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106252235560.10907-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106261422.00690.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 26, 2011, Alan Stern wrote:
> On Fri, 24 Jun 2011, Rafael J. Wysocki wrote:
> 
> > > > I'm still not clear on why the error handler needs to run at this time.
> > > 
> > > Because SATA ports are suspended with the help of the SCSI error handling
> > > mechanism (which Tejun claims is the best way to do that).
> 
> > I've carried out this exercise to see how complicated it is going to be
> > and it doesn't really seem to be _that_ complicated.  The appended patch
> > illustrates this, but it hasn't been tested, so caveat emptor.
> 
> The patch is straightforward enough.  But will it be sufficient?
> 
> Suppose a SATA port is already in runtime suspend when the system sleep
> starts.  Will the error handler be able to do its special job?  I don't
> know...  It may turn out to be necessary for the SATA port to be
> runtime resumed somewhere along the line.

That's correct, but at least in the ususal situation (i.e. sdev_gendev is
not suspended at run time) the patch makes things work when runtime PM
is disabled during system suspend and enabled during system resume.

It still may be necessary to add code to the SATA subsystem if sdev_gendev
is to be suspended at run time for SATA controllers.  I'm not aware of any
of such cases, though.

Thanks,
Rafael
