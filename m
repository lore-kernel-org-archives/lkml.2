Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1JUOnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 10:43:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40936 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753662Ab1JUOnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 10:43:39 -0400
Date: Fri, 21 Oct 2011 10:43:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: a.p.zijlstra@chello.nl, <rjw@sisk.pl>, <pavel@ucw.cz>,
        <len.brown@intel.com>, <mingo@elte.hu>, <akpm@linux-foundation.org>,
        <suresh.b.siddha@intel.com>, <lucas.demarchi@profusion.mobi>,
        <linux-pm@vger.kernel.org>, <rusty@rustcorp.com.au>,
        <vatsa@linux.vnet.ibm.com>, <ashok.raj@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <rdunlap@xenotime.net>
Subject: Re: [PATCH v3 2/3] CPU hotplug, Freezer: Synchronize CPU hotplug
 and freezer
In-Reply-To: <20111021122506.14321.51970.stgit@srivatsabhat.in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1110211042300.2131-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011, Srivatsa S. Bhat wrote:

> Don't allow the freezer subsystem to race with CPU hotplug to ensure that
> during the entire duration for which the CPU hotplug notifications are run,
> the state of the system (with respect to the tasks being frozen or not)
> remains constant.
> 
> This patch introduces four notifications in the freezer subsystem,
> PM_FREEZE_PREPARE, PM_POST_FREEZE, PM_THAW_PREPARE and PM_POST_THAW.
> These help in making other subsystems aware of the freezer's activity.
> The CPU hotplug infrastructure hooks on to these notifications and
> synchronizes with the freezer.

It seems pointless to send out PM_POST_FREEZE and PM_THAW_PREPARE 
notifications.  No task will be running to be affected by them.

Alan Stern

