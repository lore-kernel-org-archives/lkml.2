Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab2AaNuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:50:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:51914 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab2AaNuQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:50:16 -0500
Message-ID: <1328017807.2446.230.camel@twins>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Date: Tue, 31 Jan 2012 14:50:07 +0100
In-Reply-To: <4F27F0E6.1040309@redhat.com>
References: <1328016724.2446.229.camel@twins> <4F27F0E6.1040309@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 15:47 +0200, Avi Kivity wrote:

> They really need to return quickly to userspace, and they really need to
> perform some operation between rcu_assign_pointer() and returning, so no.

Bugger :/

> >
> > Compile tested only!! :-)
> >
> 
> How much did synchronize_srcu_expedited() regress?  Presumably your
> compiler didn't tell you that.

Nope, quite a lot I figure.

> Can we get it back to speed by scheduling a work function on all cpus? 
> wouldn't that force a quiescent state and allow call_srcu() to fire?
> 
> In kvm's use case synchronize_srcu_expedited() is usually called when no
> thread is in a critical section, so we don't have to wait for anything
> except the srcu machinery.

OK, I'll try and come up with means of making it go fast again ;-)
