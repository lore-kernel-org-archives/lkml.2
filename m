Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab1HPUKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 16:10:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab1HPUKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 16:10:47 -0400
Date: Tue, 16 Aug 2011 13:10:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] prctl: add PR_{SET,GET}_CHILD_REAPER to allow simple
 process supervision
Message-Id: <20110816131010.7a6e9a99.akpm@linux-foundation.org>
In-Reply-To: <1311897706.16657.2.camel@mop>
References: <1311897706.16657.2.camel@mop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 02:01:44 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Lennart Poettering <lennart@poettering.net>
> Subject: prctl: add PR_{SET,GET}_CHILD_REAPER to allow simple process supervision
> 
> Userspace service managers/supervisors need to track their started
> services. Many services daemonize by double-forking and get implicitely
> re-parented to PID 1. The process manager will no longer be able to
> receive the SIGCHLD signals for them.
> 
> With this prctl, a service manager can mark itself as a sort of
> 'sub-init' process, able to stay as the parent process for all processes
> created by the started services. All SIGCHLD signals will be delivered
> to the service manager.
> 
> As a side effect, the relevant parent PID information does not get lost
> by a double-fork, which results in a more elaborate process tree and 'ps'
> output.
> 
> This is orthogonal to PID namespaces. PID namespaces are isolated
> from each other, while a service management process usually requires
> the serices to live in the same namespace, to be able to talk to each
> other.
> 
> Users of this will be the systemd per-user instance, which provides
> init-like functionality for the user's login session and D-Bus, which
> activates bus services on on-demand. Both will need init-like capabilities
> to be able to properly keep track of the services they start.
> 

Interesting patch.  I can't immediately see any nasty effects from it..

Did you consider using the existing taskstats capability for this?

The comment block over find_new_reaper() is now incomplete.  Please
update it?

prctl(2) has a manpage.  What's the plan for updating it?

