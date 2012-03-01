Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab2CABW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:22:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45736 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab2CABW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:22:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rientjes@google.com designates 10.68.212.3 as permitted sender) smtp.mail=rientjes@google.com; dkim=pass header.i=rientjes@google.com
Date: Wed, 29 Feb 2012 17:22:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Pawe=C5=82_Sikora?= <pawel.sikora@agmk.net>
cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [3.2.2] oom + no-killable-processes.
In-Reply-To: <1888499.Wt33pfNhUs@vmx>
Message-ID: <alpine.DEB.2.00.1202291719400.17729@chino.kir.corp.google.com>
References: <3905756.9FRF7uBtcE@vmx> <20120229200910.GB31348@kroah.com> <1888499.Wt33pfNhUs@vmx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-997887433-1330564946=:17729"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-997887433-1330564946=:17729
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 29 Feb 2012, Paweł Sikora wrote:

> > > Hi all,
> > > 
> > > i've found on my 8-core opterons following oops (oom+nokillable): http://imgbin.org/index.php?page=image&id=6945
> > > usualy the kernel just kills processes from userspace but this time something has gone wrong...
> > > sysrq was dead, so no more stacktraces :/
> > 
> > Is this something new with 3.2.2?
> 
> i see such nokillable oom first time. the 3.1.x stable has been working for few months.
> as you can see on the oops timestamp the 3.2.2 failed after ~27.5d so it isn't an immediate
> crash which can be easily bisected :/ currently i'm stressing the 3.2.7...
> 

The trace you posted isn't very useful because all the important 
information has already scrolled off the screen.

This only happens if all eligible threads are oom disabled.  If you're not 
using cpusets or mempolicies or the memory controller, check 
/proc/pid/oom_score for all pids.  Those with a score of '0' are 
unkillable.  If there are threads that should be eligible, check 
/proc/pid/oom_score_adj for that pid.  If it is -1000, then userspace has 
probably disabled oom killing for it unnecessarily.

If you're using cpusets or the memory controller, then the system will 
panic if the oom occurred because all cpuset mems or the memcg limit is 
exhausted and there are also no threads in that cpuset or memcg that are 
killable (same process above).
--397155492-997887433-1330564946=:17729--
