Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0LOFev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 00:34:51 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:45873 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0LOFeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 00:34:50 -0500
Date: Wed, 15 Dec 2010 11:04:46 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
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
Message-ID: <20101215110446.157bbb25@suzukikp>
In-Reply-To: <AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com>
References: <20101214152259.67896960@suzukikp>
 <AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 07:49:37 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Dec 14, 2010 at 1:52 AM, Suzuki K. Poulose <suzuki@in.ibm.com> wrote:
> >
> > This is series of patches implementing an infrastructure for capturing the core
> > of an application without disrupting its process semantics.
> >
> > The infrastructure makes use of the freezer subsystem in kernel to freeze the
> > threads and then collect the information to generate  the core.
> 
> This seems to be a fundamentally flawed approach.
> 
> From a security standpoint, it looks like a total disaster. A frozen
> process is really hard to get rid of, so it looks like an obvious DoS
> attack to just create lots of processes, then sneakily freeze them
> all, and then laugh at the poor system admin who has no idea what's
> going on. While frozen, the things are basically unkillable but look
> entirely normal, no?

You are right. We need a simple mechanism to hold the threads, so that we 
could collect the register information of the process without affecting its 
process semantics (eg, signals etc.). The suggestion by Kamezawa-san -a 
freeze state variant which allows SIGKILL - is one possibility.

I'd be very glad not using the freezer if there is a neat way to accomplish 
this without the undesired side effects. Tejun's ptrace enhancement would 
still require a userland program to control it(gcore); something contained 
in the kernel would be ideal.


Thanks

Suzuki

> 
>                                      Linus

