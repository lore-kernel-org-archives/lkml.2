Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab0IBU3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:29:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab0IBU3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:29:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] libata: skip EH autopsy and recovery during suspend
Date: Thu, 2 Sep 2010 22:28:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201009022216.45303.rjw@sisk.pl> <4C800829.9040802@gmail.com>
In-Reply-To: <4C800829.9040802@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009022228.07626.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010, Tejun Heo wrote:
> Hello,
> 
> On 09/02/2010 10:16 PM, Rafael J. Wysocki wrote:
> > Putting the issue at hand aside, I'm not really sure if using SCSI EH for
> > suspending the controller is a good idea.  It seems overly complicated and
> > it doesn't match the new PCI suspend model with separate ->suspend(),
> > ->freeze() and ->poweroff() callbacks.  Moreover, the passing of pm_message_t
> > back and forth doesn't make things clear either.
> > 
> > Would it be possible to rework this thing entirely at one point?
> 
> Well, I think I would need more than that to rework the whole thing.
> There are a lot of benefits in sharing the same path between probing /
> error handling and suspend/resuming.  ATA has a lot of quirks which
> have to be dealt with and it will be very fragile to scatter handling
> logics over multiple separate paths.  We definitely can try to make
> the plumbing from power management easier to follow.

That would be very nice.  In particular, I'd like to get rid of the
pm_message_t thing if possible.  And I'd like to avoid putting the
controller into D3 before creating hibernation image. :-)

Thanks,
Rafael
