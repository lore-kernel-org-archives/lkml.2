Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1K3GtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 01:49:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65406 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1K3GtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 01:49:03 -0500
Date: Wed, 30 Nov 2011 10:48:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen
 cgroup
Message-ID: <20111130064857.GL1775@moon>
References: <20111128120813.GK1775@moon>
 <20111128160844.GB18864@google.com>
 <20111129225853.GA693@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129225853.GA693@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 02:58:53PM -0800, Matt Helsley wrote:
> On Mon, Nov 28, 2011 at 08:08:44AM -0800, Tejun Heo wrote:
> > On Mon, Nov 28, 2011 at 04:08:13PM +0400, Cyrill Gorcunov wrote:
> > > In checkpoint/restore we need an ability to attach pids to
> > > a frozen cgroup. Thus once pid reaches a frozen cgroup it is
> > > not rejected, but the task get frozen immediately.
> 
> Frankly, I don't see the need for this. I think you should explain
> it with more detail at the very least.
> 
> Why can't they be frozen before being checkpointed? Assuming you've
> used SEIZE and spawned a new parasite thread, just move that thread to a 
> cgroup for the parasitic threads then freeze the old cgroup.
> 

Hi Matt,

At moment there is no way to use ptrace with frozen task (Tejun
will take a look into such ability once he get time for, as far
as I know).

Ideally we would like to move checkpointing tasks to cgroup,
freeze it there and _then_ run ptrace and inject parasite code
into it. Finally the parasite code would dump tasks contents,
detach itself and unfreeze tasks.

At restore time we would like to move the tasks being restored
into frozen cgroup before final jump to the original pt_regs the
task had at checkpoint time (it actually takes a few stages, ie once
memory and other resources are restored but task is not yet
switched to the former pt_regs, we move it into frozen cgroup,
and then the task get immediately frozen, finally once all processes
being restored reaches this point we unfreeze the cgroup and
they all switch to original registers contents and continue
execution).

	Cyrill
