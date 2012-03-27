Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab2C0WmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:42:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38614 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab2C0WmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:42:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] firmware_class: Move request_firmware_nowait() to workqueues
Date: Wed, 28 Mar 2012 00:21:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203260000.34377.rjw@sisk.pl> <1332883710-7486-2-git-send-email-sboyd@codeaurora.org> <20120327220108.GB22371@google.com>
In-Reply-To: <20120327220108.GB22371@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203280021.27582.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 28, 2012, Tejun Heo wrote:
> On Tue, Mar 27, 2012 at 02:28:30PM -0700, Stephen Boyd wrote:
> > Oddly enough a work_struct was already part of the firmware_work
> > structure but nobody was using it. Instead of creating a new
> > kthread for each request_firmware_nowait() call just schedule the
> > work on the long system workqueue. This should avoid some overhead
> > in forking new threads when they're not strictly necessary.
> > 
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> > 
> > Is it better to use alloc_workqueue() and not put these on the system
> > long workqueue?
> 
> No, just use schedule_work() unless there are specific requirements
> which can't be fulfilled that way (e.g. it's on memory allocation
> path, may consume large amount of cpu cycles, ...)

It may wait quite long.

Rafael
