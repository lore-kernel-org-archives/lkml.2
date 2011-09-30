Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1I3ElD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:41:03 -0400
Received: from claw.goop.org ([74.207.240.146]:43828 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1I3ElB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:41:01 -0400
Message-ID: <4E854859.4020105@goop.org>
Date: Thu, 29 Sep 2011 21:40:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 0/8] jump-label: allow early jump_label_enable()
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com> <1317343975.4588.36.camel@gandalf.stny.rr.com>
In-Reply-To: <1317343975.4588.36.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2011 05:52 PM, Steven Rostedt wrote:
> On Thu, 2011-09-29 at 16:26 -0700, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> One big question which arises is whether the _early() function is
>> necessary at all.  All the stop_machine/mutex/etc stuff that
>> arch_jump_label_transform() ends up doing is redundant pre-SMP, but it
>> shouldn't hurt.  Maybe we can just drop the _early function?  It works
>> on x86, at least, because jump_label_enable() works, which uses the full
>> form.  And dropping it would reduce this to a very much smaller series.
> It does slow down the boot process, which is not a good thing when
> everyone is pushing for the fastest restarts.

Would it really though?  stop_machine() doesn't do very much when there
are no other cpus.

Not that I measured or anything, but there was no obvious big lag at boot.

> What we should probably do is have a global read_mostly variable called,
> smp_activated or something, then things that can be called before and
> after can read this variable to determine if it can skip certain
> protections.

Could do that if it turns out to be a problem.

> While we're at it, perhaps we could add a memory_initialized for things
> like tracers that want to trace early but need to wait till it can
> allocate buffers. If we had this flag, it could instead do an early
> memory init to create the buffers.

That seems orthogonal to the jump_label changes.

    J
