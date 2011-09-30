Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1I3Aw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 20:52:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1I3Aw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 20:52:57 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=eMQ7hR_6lG4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=tHz9FfFoAAAA:8 a=hJUw3UrrG-n1DAumEp0A:9 a=PUjeQqilurYA:10 a=6O0IECtVFhoA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH RFC 0/8] jump-label: allow early jump_label_enable()
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Thu, 29 Sep 2011 20:52:53 -0400
In-Reply-To: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317343975.4588.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 16:26 -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 

> One big question which arises is whether the _early() function is
> necessary at all.  All the stop_machine/mutex/etc stuff that
> arch_jump_label_transform() ends up doing is redundant pre-SMP, but it
> shouldn't hurt.  Maybe we can just drop the _early function?  It works
> on x86, at least, because jump_label_enable() works, which uses the full
> form.  And dropping it would reduce this to a very much smaller series.

It does slow down the boot process, which is not a good thing when
everyone is pushing for the fastest restarts.

What we should probably do is have a global read_mostly variable called,
smp_activated or something, then things that can be called before and
after can read this variable to determine if it can skip certain
protections.

While we're at it, perhaps we could add a memory_initialized for things
like tracers that want to trace early but need to wait till it can
allocate buffers. If we had this flag, it could instead do an early
memory init to create the buffers.

-- Steve


