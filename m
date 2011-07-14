Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab1GNXVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:21:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab1GNXVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:21:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=XCsRTbL4h2aR6JOWiZitTCqxrHOTXU7M1jiw3+BbaWuSHyHBH4w6GkikJa0zQDmEZ
	94ps++OX+Wc83fPIw1jjA==
MIME-Version: 1.0
In-Reply-To: <20110715000037.3fc1670a@lxorguk.ukuu.org.uk>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <1310675693-9204-2-git-send-email-mikew@google.com> <20110714234248.7ed43534@lxorguk.ukuu.org.uk>
 <CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com> <20110715000037.3fc1670a@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Date: Thu, 14 Jul 2011 16:20:59 -0700
Message-ID: <CAGTjWtA5qobWAZb=SbM1y5SFtDKPuJVuAsbDKmkaxxL7mA6OKg@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 4:00 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > a) you can do this with a security module
>>
>> I can?   How?   The whole LSM approach seems intractable to me.
>
> It would certainly need some trivial tweaking (to be specific we'd need
> to move from capable(x) to capable_syscall(x, syscall_code) for those
> interfaces that mattered, but that would probably be a good thing anyway
> from the point of view of beating the capability model into something more
> flexible and would help stuff like SELinux as well I think.

The idea of building more obtuse logic on top of posix capabilities
made me puke in my mouth :(

>
> We have an underlying separation of security from the other details - we
> really should keep it clean that way.

An aspect oriented approach to security is probably fine for
environments where you want to allow somebody access to features.

In my case, I simply don't want these "features", which is why I took
the compile time approach to turning this stuff off.  I realize that
these syscalls (and the /dev/port interface) are not comprehensive (I
didn't say they were either).  I'm happy though to take suggestions
for stuff I probably should be disabling considering my goal of making
it difficult for root to compromise a system.  And yes, modules are
disabled :)
