Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1I2NMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:12:42 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:36853 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1I2NMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:12:41 -0400
Subject: Re: Jump Label initialization
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jason Baron <jbaron@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <1317300028.4588.15.camel@gandalf.stny.rr.com>
References: <4E83D49C.9080809@goop.org>
	 <1317297894.23938.9.camel@localhost.localdomain>
	 <1317300028.4588.15.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Sep 2011 15:10:26 +0200
Message-ID: <1317301826.23938.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 08:40 -0400, Steven Rostedt wrote:
> On Thu, 2011-09-29 at 14:04 +0200, Jan Glauber wrote:
> > On Wed, 2011-09-28 at 19:14 -0700, Jeremy Fitzhardinge wrote:
> > > Hi all,
> > > 
> > > I'm trying to use the jump label machinery as part of the pv ticketlock
> > > work I'm doing on x86.
> > > 
> > > The problem I'm having at the moment is that I do my spinlock setup in
> > > smp_prepare_boot_cpu(), which happens before jump_label_init() gets
> > > called, and so the latter goes and nops out all my enabled jump label key.
> > > 
> > > I'm experimenting at the moment with a patch to allow
> > > jump_label_enable() to be called fairly early, and have that be
> > > respected by jump_label_init().  I'm doing this by replacing
> > > arch_jump_label_poke_text_early() with
> > > arch_jump_label_transform_early(), which shares most of its code with
> > > its non-early variant, except that it expects to run in a pre-SMP
> > > environment.
> > > 
> > > Does this seem plausible? (I haven't tested it yet.)
> > > 
> > > The x86, mips and sparc patches are fairly simple; I forgot to look at
> > > powerpc, and I didn't fully investigate s390.
> > 
> > s390 does not have the early() variant since it didn't need it. On
> > pre-SMP we probably don't need stop_machine() so creating
> > arch_jump_label_transform_early() by leaving out stop_machine()
> > and patching the code directly should be fine.
> 
> Also note that stop_machine() may only be needed by a few archs (maybe
> only x86).

s390 needs stop_machine() too. Instructions may be fetched multiple
times for a single execution and may also be fetched piecemeal.

--Jan

