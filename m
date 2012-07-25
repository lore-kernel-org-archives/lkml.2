Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201Ab2GYO5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:57:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37892 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964774Ab2GYO5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:57:19 -0400
Date: Wed, 25 Jul 2012 10:57:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: tglx@linutronix.de, <mingo@kernel.org>, <peterz@infradead.org>,
        <rusty@rustcorp.com.au>, <paulmck@linux.vnet.ibm.com>,
        <namhyung@kernel.org>, <tj@kernel.org>, <rjw@sisk.pl>,
        <nikunj@linux.vnet.ibm.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers
 during CPU hotplug
In-Reply-To: <20120725115224.3900.80783.stgit@srivatsabhat.in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1207251054420.2008-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Srivatsa S. Bhat wrote:

> Hi,
> 
> This patchset implements the approach of invoking the CPU hotplug callbacks
> (notifiers) in one order during CPU online and in the reverse order during CPU
> offline. The rationale behind this is that services for a CPU are started in a
> particular order (perhaps, with implicit dependencies between them) while
> bringing up the CPU, and hence, it makes sense to tear down the services in
> the opposite order, thereby honoring most of the dependencies automatically
> (and also correctly). This is explained in more detail in Patch 6.

This strongly suggests that a notifier chain may be the wrong mechanism
to use here.  Notifiers provide only limited guarantees about ordering,
and it's hard to say much about the services a particular chain will
provide since callbacks can be added from anywhere.

Instead of adding all this complication to the notifier mechanism, how 
about using something else for CPU hotplug?

Alan Stern

