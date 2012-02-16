Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2BPPNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:13:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43264 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753163Ab2BPPNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:13:31 -0500
Date: Thu, 16 Feb 2012 10:13:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zhang Rui <rui.zhang@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
In-Reply-To: <1329376686.28581.15.camel@rui.sh.intel.com>
Message-ID: <Pine.LNX.4.44L0.1202161010500.1268-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012, Zhang Rui wrote:

> > I'm not exactly sure what you're trying to achieve and what you mean by
> > "resume a device directly"?  Do you want to run the device's resume
> > callback at the time when another device is being resumed?
> > 
> I mean, wakeup event is sent to ATA port, but our goal is to resume
> ZPODD after receiving this wakeup event.
> Ideally, it is ACPI that resumes ATA port. And then, the ATA port
> runtime resumes ZPODD. But this does not look good to runtime resume a
> child device in the parent's .runtime_resume callback.
> So I introduced these two APIs so that an runtime_resume request can be
> sent to ZPODD directly and the runtime PM core can resume all the
> parents of ZPODD automatically.

It's not clear what you're trying to achieve.  Do you basically want
the ZPODD always to be suspended and resumed along with the ATA port,
or should it be possible to suspend the ZPODD while the port remains
running?

Alan Stern

