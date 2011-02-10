Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1BJRxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:53:47 -0500
Received: from zakopane.cs.ubc.ca ([198.162.52.68]:42718 "EHLO
	mail.quuxuum.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1BJRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:53:46 -0500
Date: Thu, 10 Feb 2011 09:53:44 -0800
From: Brendan Cully <brendan@cs.ubc.ca>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>, Alan@cs.ubc.ca,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Stern <stern@rowland.harvard.edu>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>
Subject: Re: [Xen-devel] Re: [linux-pm] [PATCH 0/2] Fix hangup after creating
 checkpoint on Xen.
Message-ID: <20110210175344.GB380@zanzibar.kublai.com>
Mail-Followup-To: Ian Campbell <ijc@hellion.org.uk>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	LKML <linux-kernel@vger.kernel.org>, Alan@cs.ubc.ca,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stern <stern@rowland.harvard.edu>,
	"linux-pm@lists.linux-foundation.org" <linux-pm@lists.linux-foundation.org>,
	"SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>
References: <Pine.LNX.4.44L0.1102081143470.2100-100000@iolanthe.rowland.org>
 <1297186554.9388.248.camel@zakaz.uk.xensource.com>
 <20110209231659.GB249@zanzibar.kublai.com>
 <1297337473.20491.144.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297337473.20491.144.camel@zakaz.uk.xensource.com>
X-Operating-System: Darwin 10.6.0 i386
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 10 February 2011 at 11:31, Ian Campbell wrote:
> On Wed, 2011-02-09 at 23:16 +0000, Brendan Cully wrote:
> > I'd like to keep the fast resume option, and expect that it can be
> > contained entirely in Xen-specific code. I'll try to get someone to
> > look into it here.
> 
> Thanks, please put them in contact with Kazuhiro who has already been
> looking into this.
> 
> > I think fast resume is somewhat orthogonal to the problem of hanging
> > on resume, which just sounds like a xen-specific bug in the slow
> > path.
> 
> The bug on the Xen side is taking the slow path when the suspend was
> actually cancelled, which is what the original patch tries to fix.
> 
> Or should/could the slow path be able cope either way?

I haven't looked at what's actually happening yet, but what should be
happening is that the pvops kernel should not advertise SUSPEND_CANCEL
since it doesn't yet support it. So xm save -c should call
xc_domain_resume with the fast argument set to 0, to do slow path
resumption, and that slow path should be able to handle resuming on
the same host where it suspended. Slow path resumption from checkpoint
was supported in the pre-pvops kernel.
