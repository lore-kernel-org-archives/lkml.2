Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0LAAiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:38:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60072 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab0LAAiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:38:10 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=qK-MKYc896kA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ynXvPYKekihUIqgo6nEA:9 a=wS7eadoTgYCPFoBayOXZK5SalQAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: mat <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Kees Cook <kees.cook@canonical.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20101130222025.3ccf5c00@mat-laptop>
References: <4CE2F914.9070106@free.fr>
	 <20101129181542.GA11630@home.goodmis.org>
	 <20101130222025.3ccf5c00@mat-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 30 Nov 2010 19:38:05 -0500
Message-ID: <1291163885.4881.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 22:20 +0100, mat wrote:

> That's look fine for me.
> 
> But I wonder why ftrace_arch_code_modify_prepare isn't called ?
> 
> It is only called when we start/stop tracing ?

Correct. There's no reason to use it for the changing of mcount callers
to nops. For core kernel code, it happens before SMP is enabled. For
modules, it happens before the module code is executed. Except for what
Rusty stated with the module parameters, but if you are executing
complex code with that, you deserve what you get ;-)

The initial changes are made outside of stop machine. The code is not
being executed by anyone else.

-- Steve


