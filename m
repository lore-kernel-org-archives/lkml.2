Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab0IBVeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:34:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55442 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755401Ab0IBVeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:34:10 -0400
Date: Thu, 2 Sep 2010 17:34:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Colin Cross <ccross@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after
 abort
In-Reply-To: <AANLkTim7UM80MrwKoAz3hUFrqL2Fbyw6XS=X89PXRc2Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1009021723460.1311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Colin Cross wrote:

> That would work, but I still don't see why it's better.  With either
> of your changes, the power.completion variable is storing state, and
> not just used for notification.  However, the exact meaning of that
> state is unclear, especially during the transition from an aborted
> suspend to resume, and the state is duplicating power.status.  Setting
> it to complete in dpm_prepare is especially confusing, because at that
> point nothing is completed, it hasn't even been started.

The state being waited for varies from time to time and is only
partially related to power.status.  Instead of using a completion I
suppose we could have used a new "transition_complete" variable
together with a waitqueue.  Would you prefer that?  It's effectively
the same thing as a completion, but without the nice packaging already 
provided by the kernel.

Alan Stern

