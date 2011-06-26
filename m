Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1FZCj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 22:39:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47388 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752085Ab1FZCjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 22:39:25 -0400
Date: Sat, 25 Jun 2011 22:39:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] PCI / PM: Block races between runtime PM and system
 sleep
In-Reply-To: <201106240059.38687.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106252235560.10907-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011, Rafael J. Wysocki wrote:

> > > I'm still not clear on why the error handler needs to run at this time.
> > 
> > Because SATA ports are suspended with the help of the SCSI error handling
> > mechanism (which Tejun claims is the best way to do that).

> I've carried out this exercise to see how complicated it is going to be
> and it doesn't really seem to be _that_ complicated.  The appended patch
> illustrates this, but it hasn't been tested, so caveat emptor.

The patch is straightforward enough.  But will it be sufficient?

Suppose a SATA port is already in runtime suspend when the system sleep
starts.  Will the error handler be able to do its special job?  I don't
know...  It may turn out to be necessary for the SATA port to be
runtime resumed somewhere along the line.

Alan Stern

