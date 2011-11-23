Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1KWQU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:20:57 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:54999 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1KWQUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:20:55 -0500
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given pids
Date: Wed, 23 Nov 2011 16:20:44 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-12-generic; KDE/4.7.2; x86_64; ; )
Cc: Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
References: <4EC4F2FB.408@parallels.com> <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com>
In-Reply-To: <20111122153326.GD322@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111231620.45440.pedro@codesourcery.com>
X-OriginalArrivalTime: 23 Nov 2011 16:20:47.0918 (UTC) FILETIME=[DBF6ECE0:01CCA9FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On Tuesday 22 November 2011 15:33:26, Tejun Heo wrote:
> Hello,
> 
> On Tue, Nov 22, 2011 at 12:04:38PM +0000, Pedro Alves wrote:
> > This whole userspace C/R stuff and being able to set the child's pid has potential
> > of being very useful for GDB too, allowing a much better reimplementation of its
> > old checkpointing feature [*], and allowing for a faster reverse debugging
> > implementation, by being able to do faster rewinding -- restore snapshot and replay
> > instructions up to N (by single stepping or running to breakpoint), rather than
> > manually undoing the effects of each instruction, one by one.
> > 
> > IOW, root only would be a shame from GDB's perspective.
> 
> Would CAP_CHECKPOINT be a shame too?  

I think CAP_CHECKPOINT (or something through some LSM) would be
definitely better.

> I'm reluctant about priviledge
> through fd inheritance mostly because of its unusualness.  I don't
> think priv management is a good problem space for small creative
> solutions.  We're much better off with mundane mechanisms which people
> are already familiar with and is easy to account for.

fd inheritance wouldn't work for gdb; a user spawned gdb
wouldn't inherit an open fd to kernel.ns_last_pid from anywhere.

-- 
Pedro Alves
