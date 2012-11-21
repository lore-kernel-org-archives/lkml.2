Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2KUAzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:55:43 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33467 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2KUAzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:55:42 -0500
Date: Wed, 21 Nov 2012 01:00:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>,
        Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v2] devtmpfs: mount with noexec and nosuid
Message-ID: <20121121010056.2b4d3e7a@pyramind.ukuu.org.uk>
In-Reply-To: <CAGXu5jLeo2Qcn8x=CtBXoNaz7UsZaZTbhjFevqon2JbBhm+Otw@mail.gmail.com>
References: <20121120204238.GA19554@www.outflux.net>
	<20121120211312.57f1b63d@pyramind.ukuu.org.uk>
	<CAGXu5jJv58UGwsWM=+ZSnaNpymh6Sm6xSjc0JuT+QoZ9U2++rw@mail.gmail.com>
	<20121120235353.3092c8d2@pyramind.ukuu.org.uk>
	<CAGXu5jKS1OQPxiBPewtfOTJqntOMFnw4n08-zP7=87nD+z6eSg@mail.gmail.com>
	<20121121002412.1c957ad2@pyramind.ukuu.org.uk>
	<CAGXu5jLeo2Qcn8x=CtBXoNaz7UsZaZTbhjFevqon2JbBhm+Otw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 16:41:27 -0800
Kees Cook <keescook@chromium.org> wrote:

> On Tue, Nov 20, 2012 at 4:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> > You just broke my bullshitometer
> >> >
> >> > It's a single syscall from your init binary, its microseconds.
> >>
> >> Whatever, I still see it as a needless inefficiency.
> >
> > As opposed to adding permanent kernel code and having to change the
> > setting by recompilation, and not being able to deploy this with older
> > kernels.
> 
> Some organizations only support their single "current" kernel, and
> always move forward.

This is not GNOME. Your specific organisational choices are not the sole
decider.

> I'm not interested in those things.

This is not GNOME. 

> that this clear lack of security best-practice (W^X) in the kernel
> isn't the place to fix it, I'll move on. There are still legacy video
> drivers and things that can't operate with this configuration, but the
> kernel mounting devtmpfs shouldn't _require_ userspace to clean up
> after a buggy kernel.

The kernel is not "buggy". It merely has defaults you don't personally
like. They are configurable via userspace. Policy belongs in userspace.

> > Wrong. Big time wrong. A page is 4096 bytes, your change is probably
> > about 8. So 1 in 512 builds will see an extra page of kernel space used
> > assuming an even distribution. For each of those users the moment they've
> > had a few page faults your solution is *less* efficient, and the moment
> > they've paged one page because of having less memory your solution has
> > become vastly less efficient.
> 
> My patch doesn't change the code size there after the most recent
> change to use a constant value again, so the only change I can see
> would be if someone built with /proc/config.gz which would show the
> new config.

So in actual fact going by distro choices its worse than I thought 8)

> Heh, I support your dig at GNOME, but refute this being a "specific
> personal need". Best-practices are clear here. The only reason the
> kernel hasn't been doing it is fear of breaking legacy video drivers.

Thats not true. Nor is it a case of "Not doing". This feature has been
supported for over ten years. We also support more flexible alternatives
like using SELinux, Smack or AppArmor for it. Right now I can do no exec
for /dev except for specific files entirely by security rules.

> Security is layers, and is never perfect. We already do a fair bit of
> process confinement, but this change seemed to be clear low-hanging
> fruit.

It's not a bad idea - but its a single userspace syscall in your init
code. Has been for over a decade.

> > We don't need extra confusion Kconfig options, we don't need extra kernel
> > code combinations to fail to maintain. Your patch offers *NO* feature
> > advantages over the existing kernel.
> 
> I disagree. It allows a system builder to opt-in to correcting a
> kernel flaw introduced by the need to support legacy devices in the
> case where an initramfs isn't used.

Thats a fiction you invented. It's completely irrelevant to most systems
and its already long supported. I think doing that mount in Chrome is
sensible. I think doing it in userspace as we've supported for over a
decade is rather smarter than kernel hacks. You don't have to pee in
other people's ponds that way or achieve consensus you can just go do
what you need.

> I don't understand why you're so violently opposed to letting an
> arguably flawed constant get fixed. I'm not even asking for this to be
> on by default.

Because its a pointless option. It adds nothing but an extra Kconfig
option for everyone. It's a complete waste. Policy belongs in user space.

Fix your userspace. It can't be *that* hard to add a mount call to a
chromium init. It's hardly rocket science. That gives you what you want,
avoids more configuration options, and doesn't mess up compatibility or
add confusing interactions for those users already using more flexible
security options than your mount.

Alan
