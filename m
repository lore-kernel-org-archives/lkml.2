Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954Ab2EYA1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 20:27:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63959 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758913Ab2EYA1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 20:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <4FBECAC2.6050303@zytor.com>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk> <1337875681-20717-1-git-send-email-wad@chromium.org>
 <alpine.LRH.2.02.1205250932270.26644@tundra.namei.org> <CAObL_7GHEdoyzVPjhR5U0RvQhRP50e6YM83CkXifzUKOFb+KHQ@mail.gmail.com>
 <4FBECAC2.6050303@zytor.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 24 May 2012 17:26:54 -0700
X-Google-Sender-Auth: LCPy_F0IYAjuJAEXp0lC3hIGO8k
Message-ID: <CAObL_7GSNbgceHQpNx3fbiCbV5u-_vJJO5cptwVCK34W7wFH5Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] move the secure_computing call
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Morris <jmorris@namei.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, mcgrathr@google.com, indan@nul.nu,
        netdev@parisplace.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        serge.hallyn@canonical.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 4:56 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/24/2012 04:43 PM, Andrew Lutomirski wrote:
>>
>> IMO the behavior should change.  Alternatively, a post-ptrace syscall
>> should have to pass the *tracer's* seccomp filter, but that seems
>> overcomplicated and confusing.
>>
>> OTOH, allowing ptrace in a seccomp filter is asking for trouble anyway
>> -- if you can ptrace something outside the sandbox, you've escaped.
>>
>
> This is my suggestion: if there is demand, make it possible to install a
> *second* seccomp filter program which is run on the result of the
> ptrace.  I.e.:
>
> Untraced:       process -> seccomp1 -> kernel
>
> Traced:         process -> seccomp1 -> ptrace -> seccomp2 -> kernel

Just to clarify: are you suggesting that, for now, the traced behavior
should be:

process -> seccomp -> ptrace -> kernel?

If so, I think the man page or something should have a big fat warning
that seccomp filters should *never* allow ptrace (even PTRACE_TRACEME)
unless they fully understand the issue.

In any case, I think that the UML interaction is missing the point.
UML will *emulate* the seccomp filter.  If it chooses to use host
seccomp filters for some business, that's its business.

--Andy
