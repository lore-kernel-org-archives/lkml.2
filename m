Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0LPH5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 02:57:11 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36170 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0LPH5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 02:57:07 -0500
Date: Thu, 16 Dec 2010 13:27:10 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>, Amerigo Wang <amwang@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [Patch 0/21] Non disruptive application core dump
 infrastructure
Message-ID: <20101216132710.73abf94d@suzukikp>
In-Reply-To: <20101215115153.GB22304@basil.fritz.box>
References: <20101214152259.67896960@suzukikp>
	<AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com>
	<20101215110446.157bbb25@suzukikp>
	<4D088C6C.8020800@kernel.org>
	<20101215165626.715007b5@suzukikp>
	<20101215115153.GB22304@basil.fritz.box>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 12:51:54 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > 1) A process can trigger a core synchronously, upon an event, say a signal 
> > handler and continue from there. gcore would require a fork(), which is not 
> > safe to use from a signal handler.
> 
> Why is it not safe for a signal?
> 
> From the kernel side it should be. glibc may do some funky things
> on fork, but you could always call the syscall directly.

I came across the following links,

http://sourceware.org/bugzilla/show_bug.cgi?id=4737
https://www.opengroup.org/austin/docs/austin_445.txt

which seem to suggest that fork() is not async-safe due to malloc and the  
fork handlers. But a direct fork syscall by-passing glibc should be safe.

Thanks
Suzuki

> 
> -Andi

