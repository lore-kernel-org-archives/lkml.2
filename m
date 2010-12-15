Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0LOL0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 06:26:21 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:38802 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab0LOL0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 06:26:20 -0500
Date: Wed, 15 Dec 2010 16:56:26 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [Patch 0/21] Non disruptive application core dump
 infrastructure
Message-ID: <20101215165626.715007b5@suzukikp>
In-Reply-To: <4D088C6C.8020800@kernel.org>
References: <20101214152259.67896960@suzukikp>
	<AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com>
	<20101215110446.157bbb25@suzukikp>
	<4D088C6C.8020800@kernel.org>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 10:37:48 +0100
Tejun Heo <tj@kernel.org> wrote:

> Hello, Suzuki.
> 
> On 12/15/2010 06:34 AM, Suzuki K. Poulose wrote:
> > I'd be very glad not using the freezer if there is a neat way to
> > accomplish this without the undesired side effects. Tejun's ptrace
> > enhancement would still require a userland program to control
> > it(gcore); something contained in the kernel would be ideal.
> 
> Why is using gcore a bad thing?  If we make ptrace avoid the implicit
> SIGSTOP, the side effects of ptrace would be the same as using freezer
> but with the benefit that it's properly integrated to the process
> model and job control.

The advantages of the new approach are :

1) A process can trigger a core synchronously, upon an event, say a signal 
handler and continue from there. gcore would require a fork(), which is not 
safe to use from a signal handler.

2) We can seek to only the data we need

Thanks
Suzuki

