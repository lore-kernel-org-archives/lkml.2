Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2ALQiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:38:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61574 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2ALQir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:38:47 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=CN4PQ-MNGcoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Fc00G34392aBtCSHeYYA:9 a=sToINQ_FQKW0xBegNAgA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326386324.7642.96.camel@gandalf.stny.rr.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Date: Thu, 12 Jan 2012 11:38:44 -0500
In-Reply-To: <20120112161418.GA22360@redhat.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	 <1326302710-9427-2-git-send-email-wad@chromium.org>
	 <1326383015.7642.77.camel@gandalf.stny.rr.com>
	 <20120112161418.GA22360@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 17:14 +0100, Oleg Nesterov wrote:

> May be this needs something like LSM_UNSAFE_SECCOMP, or perhaps
> cap_bprm_set_creds() should take seccomp.mode == 2 into account, I dunno.
> 
> OTOH, currently seccomp.mode == 1 doesn't allow to exec at all.

I've never used seccomp, so I admit I'm totally ignorant on this topic.

But looking at seccomp from the outside, the biggest advantage to this
would be the ability for normal processes to be able to limit tasks it
kicks off. If I want to run a task in a sandbox, I don't want to be root
to do so.

I guess a web browser doesn't perform an exec to run java programs. But
it would be nice if I could execute something from the command line that
I could run in a sand box.

What's the problem with making sure that the setuid isn't set before
doing an execv? Only fail when setuid (or some other magic) is enabled
on the file being exec'd.

Or is this a race where I can have a soft link pointing to a normal
file, run this, and have the link change to a setuid file at just the
right time that causes it to happen?


-- Steve


