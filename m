Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1FIFL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 01:11:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56182 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1FIFL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 01:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ppYCYJ676Sodg52A+ejx52dUvymfOjJRDUVG/jIMoBDPbN6URHnUenPUMmbk3gn9/+
         T3BVsIdbdaW7/tqn+GwY1PJxLVR4RVZ8zuyL+C3fOC1lVqcjFst6lL05I870r3Hu6pfk
         rstfIMfGHfyD/PX3razXhpRjSsr6pHsvhpsdw=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Darren Hart <dvhart@linux.intel.com>, George Spelvin <linux@horizon.com>,
        david@rgmadvisors.com, kyle@moffetthome.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=E9gR3JHa4ipHHGGR2AiO9xJri=A@mail.gmail.com>
References: <20110609004435.14550.qmail@science.horizon.com>
	 <4DF037C6.4000507@linux.intel.com>
	 <BANLkTik62dLMf5PCPGeW=9P=sF2QcnW42g@mail.gmail.com>
	 <1307591659.3980.37.camel@edumazet-laptop>
	 <BANLkTi=E9gR3JHa4ipHHGGR2AiO9xJri=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 07:11:21 +0200
Message-ID: <1307596281.3980.59.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 juin 2011 à 00:10 -0400, Andrew Lutomirski a écrit :
> On Wed, Jun 8, 2011 at 11:54 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > You can not prevent DOS on a machine if you allow a process to RO map
> > your critical files (where you put futexes), because you allow this
> > process to interfere with critical cache lines bouncing between cpus.
> 
> The cacheline bounce DoS slows things down and they go back to normal
> when you kill the DoS-ing task.
> 
> The wakeup-eating DoS is permanent.  Seems a good deal worse to me.
> 
> If you make this change, please at least document it in the man page.
> 


This is how futexes had working for years.

It was very obvious from the beginning. Please submit a man page change
since you raised the point. You own the credit to open a CVE and
immediately release a fix to all 2.6 versions !

How come a critical fix (according to you) went without being noticed
and documented ?

> Then how am I supposed to efficiently broadcast information to
> untrusted processes?  I'll have to put any futexes involved into
> different files, but one way or another the actual data will have to
> be memory mapped to avoid syscall overhead.

futexes are a linux extension over standard VM games.

If you dont know how to share a memory segment between a group of
processes, disallowing others to come spy on you, maybe its better to
use another IPC ?

Instead of 'fixing' futexes, what about educating people how to
correctly use memory segments ?



