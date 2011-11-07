Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1KGVXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:23:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46282 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1KGVXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:23:38 -0500
MIME-Version: 1.0
In-Reply-To: <4EB843FF.5080201@zytor.com>
References: <20111107174522.GA2317@albatros> <9718.1320689192@turing-police.cc.vt.edu>
 <20111107190112.GA3732@albatros> <4EB82F08.8060209@zytor.com>
 <20111107192915.GA4690@albatros> <CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
 <4EB83674.3040207@zytor.com> <20111107201120.GA5775@albatros> <4EB843FF.5080201@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Nov 2011 13:23:16 -0800
X-Google-Sender-Auth: IEtSOMCwCMzJ74CVQdhhJpYbIPk
Message-ID: <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to /proc/interrupts
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Eric Paris <eparis@parisplace.org>,
        kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 12:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> You didn't really get my point.  There are global nodes which are
> dynamic, and more importantly the *set* changes across the system life.
>  A global policy option is a lot easier to deal with for the vast
> majority of users who don't need fine grain control.

I want *one* global policy that the kernel would actually know about:
is the user physically at the machine right now.

Sadly, I don't think the kernel has any good way to figure that out
automatically.

Because quite frankly, a lot of the /proc files should be "root or
desktop user". If you control the hardware, you should damn well be
able to see the interrupt counts in order to do bug reports etc
without having to 'sudo' or similar.

I realize that pam & co could give us this info, or we could just add
a new capability flag, but I think this is something where the kernel
really could just do the RightThing(tm) automatically, and screw the
crazy login managers, odd policies (I really don't believe that adding
magic selinux rules actually improves security all that much, because
it's too painful and too hard to know for any normal user).

The person in front of the hardware really *is* fundamentally special.

Right now all the distros do magic things with the audio device
because they know the person in front of the machine is special. But
all those things are ad-hoc per device, and never cover things like
random /proc files etc.

               Linus
