Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1G0WpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:45:05 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:45032 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1G0WpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:45:00 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jul 2011 18:45:00 EDT
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/8] make vfork killable/restartable/traceable
Date: Wed, 27 Jul 2011 23:38:14 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20110727163159.GA23785@redhat.com>
In-Reply-To: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107272338.15238.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 July 2011 17:31:59, Oleg Nesterov wrote:
> Hello.
> 
> CLONE_VFORK sleeps in TASK_INTERRUPTIBLE until the child exits/execs.
> This is obviously not good, it is sooo simple to create the task which
> doesn't react to SIGKILL/SIGSTOP.
> 
> Questions:
> 
> 	- do we really need this?
> 
> 	  I think we do. This really "looks like a bug" in any case,
> 	  even if nobody ever complained afaik.
> 
> 	- may be 1-3 is enough?
> 
> 	  may be... but personally I think SIGSTOP/ptrace should work
> 	  too.

Thanks, me too.  If not SIGSTOP, then PTRACE_STOP.  The fact that it
doesn't has led to the need for workarounds in gdb.  Do you see
any way gdb will be able to check at runtime its workarounds
won't be needed anymore ?

-- 
Pedro Alves
