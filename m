Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1KHRGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:06:55 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:41803 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1KHRGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:06:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20153.24986.33414.602337@quad.stoffel.home>
Date: Tue, 8 Nov 2011 12:06:34 -0500
From: "John Stoffel" <john@stoffel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vasiliy Kulikov <segoon@openwall.com>,
        Eric Paris <eparis@parisplace.org>,
        kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [kernel-hardening] Re: [PATCH] proc: restrict access to
 /proc/interrupts
In-Reply-To: <CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
References: <20111107174522.GA2317@albatros>
	<9718.1320689192@turing-police.cc.vt.edu>
	<20111107190112.GA3732@albatros>
	<4EB82F08.8060209@zytor.com>
	<20111107192915.GA4690@albatros>
	<CACLa4puR6W+15KxpZtzAt6c2fXUhM8gkLY9Zn5RNE8qbNpO_xQ@mail.gmail.com>
	<4EB83674.3040207@zytor.com>
	<20111107201120.GA5775@albatros>
	<4EB843FF.5080201@zytor.com>
	<CA+55aFwYGivYFZTLprSB+oDm3E4MG0s3PEQabs166v6YRL5u-Q@mail.gmail.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus> On Mon, Nov 7, 2011 at 12:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> 
>> You didn't really get my point.  There are global nodes which are
>> dynamic, and more importantly the *set* changes across the system life.
>>  A global policy option is a lot easier to deal with for the vast
>> majority of users who don't need fine grain control.

Linus> I want *one* global policy that the kernel would actually know about:
Linus> is the user physically at the machine right now.

Linus> Sadly, I don't think the kernel has any good way to figure that out
Linus> automatically.

Linus> Because quite frankly, a lot of the /proc files should be "root or
Linus> desktop user". If you control the hardware, you should damn well be
Linus> able to see the interrupt counts in order to do bug reports etc
Linus> without having to 'sudo' or similar.

Linus> I realize that pam & co could give us this info, or we could just add
Linus> a new capability flag, but I think this is something where the kernel
Linus> really could just do the RightThing(tm) automatically, and screw the
Linus> crazy login managers, odd policies (I really don't believe that adding
Linus> magic selinux rules actually improves security all that much, because
Linus> it's too painful and too hard to know for any normal user).

Linus> The person in front of the hardware really *is* fundamentally special.

Except when they're my kids and I don't want them to shutdown or
suspend the box when they login/logout.   For example, I work on my
desktop at night, and after school, they just login to the same box as
their own account, do their thing, etc.  Then at night after they're
in bed, I use the same machine.  But something they've rebooted it, or
whatever.  A pain.  

Linus> Right now all the distros do magic things with the audio device
Linus> because they know the person in front of the machine is
Linus> special. But all those things are ad-hoc per device, and never
Linus> cover things like random /proc files etc.

It's really hard to know who's sitting there.  And what about
multi-seat setups?  
