Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab1JNPov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 11:44:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41560 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751332Ab1JNPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 11:44:49 -0400
Date: Fri, 14 Oct 2011 11:44:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <rdunlap@xenotime.net>,
        <len.brown@intel.com>, <pavel@ucw.cz>, <a.p.zijlstra@chello.nl>,
        <linux-pm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Documentation/power: Update docs about suspend and
 CPU hotplug
In-Reply-To: <4E97D5B0.60801@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1110141140080.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Srivatsa S. Bhat wrote:

> Update the documentation about the interaction between the suspend (S3) call
> path and the CPU hotplug infrastructure.
> This patch focusses only on the activities of the freezer, cpu hotplug and
> the notifications involved. It outlines how regular CPU hotplug differs from
> the way it is invoked during suspend and also tries to explain the locking
> involved.
> 
> v2: Clarified the question, to emphasize that the document explains only
>     the difference (and similarity) in the two code paths but not what happens
>     when race conditions occur between them.

Drawing the two diagrams in parallel, the way this does, carries a very
strong implication that the events being described happen in parallel.  
It really would be much better to have two separate diagrams and point
out the common portions.

Also, the document should discuss the issues involved in CPU hotplug.  
In particular, what happens if the CPUs are not all the same, or if the 
requiring differing microcodes.  And whether or not the microcode needs 
to get reloaded (presumably only after hibernation, not after suspend).
And what happens when a CPU is hot-unplugged and replaced with a 
differeing CPU which is then hot-plugged.

Alan Stern

