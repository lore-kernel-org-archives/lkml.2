Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1KVMEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:04:45 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:36222 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1KVMEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:04:44 -0500
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given pids
Date: Tue, 22 Nov 2011 12:04:38 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-12-generic; KDE/4.7.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
References: <4EC4F2FB.408@parallels.com> <20111121225019.GQ25776@google.com> <4ECB8346.8040806@parallels.com>
In-Reply-To: <4ECB8346.8040806@parallels.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111221204.39235.pedro@codesourcery.com>
X-OriginalArrivalTime: 22 Nov 2011 12:04:42.0115 (UTC) FILETIME=[EAD1B530:01CCA90E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 November 2011 11:11:02, Pavel Emelyanov wrote:
> > Can't we for now allow this for root and then later allow CAP_CHECKPOINT 
> > that Cyrill suggested?  Or do we want to allow setting pids even w/o CR 
> > for NS creator?
> 
> I think that systemd guys can play with it. E.g. respawning daemons with predefined
> pids sounds like an interesting thing to play with.

This whole userspace C/R stuff and being able to set the child's pid has potential
of being very useful for GDB too, allowing a much better reimplementation of its
old checkpointing feature [*], and allowing for a faster reverse debugging
implementation, by being able to do faster rewinding -- restore snapshot and replay
instructions up to N (by single stepping or running to breakpoint), rather than
manually undoing the effects of each instruction, one by one.

IOW, root only would be a shame from GDB's perspective.

[*] GDB has an old checkpointing feature ("checkpoint; info checkpoints" commands)
based on forcing the tracee to fork, and holding on the fork child behind the
scenes as a checkpoint.  To restore the debugging state to a previous checkpoint,
gdb swaps the current debuggee for the fork child as transparently for the user
as was possible. Obviously this has a bunch of limitations and downsides like
only working on non-threaded programs, and the inferior's pid changing...

-- 
Pedro Alves
