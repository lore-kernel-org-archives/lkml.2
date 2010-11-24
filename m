Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0KXI3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:29:49 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58084 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0KXI3s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:29:48 -0500
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <1290553854.30543.406.camel@gandalf.stny.rr.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <1290548527.30543.401.camel@gandalf.stny.rr.com>
	 <20101123215604.GC4715@redhat.com>
	 <1290553854.30543.406.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 09:29:22 +0100
Message-ID: <1290587362.2072.429.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 18:10 -0500, Steven Rostedt wrote:

> Anyway, I just tried what you explained with the current kernel, with
> and without jump labels and, without jump labels, the module has its
> kmalloc tracepoint traced, but with jump labels it does not. So we can
> treat this as a regression, which is something that can go into an -rc.
> 
> The change log must state that this _is_ a regression, or Linus may not
> accept it.

I really dislike the first patch... Preferably I'd simply fully revert
all the jump-label stuff and try again next round with a saner
interface.

There's a really good simple fix for this, simply disable the gcc
trickery for .37 and use the fallback.

Then for .38, mandate the key type to be atomic_t * and switch to the
SWITCH_POINT() interface from hpa.
