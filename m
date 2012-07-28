Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2G1B3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 21:29:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2G1B2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 21:28:40 -0400
Date: Fri, 27 Jul 2012 18:26:32 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Colin Cross <ccross@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 0/7] KDB: Kiosk (reduced capabilities) mode
Message-ID: <20120728012632.GA1766@lizard>
References: <20120726142514.GA32158@lizard>
 <CAMbhsRSM3QwwVfUMBWq1bDJxHX+Ox2CQtbvJVmemuMWjxfmDoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMbhsRSM3QwwVfUMBWq1bDJxHX+Ox2CQtbvJVmemuMWjxfmDoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:30:49PM -0700, Colin Cross wrote:
> > The are two use-cases for the mode, one is evil, but another is quite
> > legitimate.
> >
> > The evil use case is used by some (ahem) phone manufaturers that want
> > to have a debuging facilities on a production device, but still don't
> > want you to use the debugger to gain root access. I don't like locked
> > phones, and I would not touch this/get my hands dirty by implementing
> > the feature just for this evil (IMHO) use case.
> 
> The point of the reduced feature set in FIQ debugger is not to prevent
> you from accessing your own phone, it designed to prevent others from
> trivially rooting your phone and reading your data.  Both locked and
> unlocked phones run FIQ debugger.  Would you carry a phone with
> personal data on it and KGDB enabled on the serial console?

Short answer: yes, I would carry such a phone. :-)

Long answer:

If someone was so interested in cracking the phone/data and so
ended up with attaching serial console and attempted to use debugger 
techniques to gain access to my data, then thief's next step would be
soldering a few wires to JTAG spots, and it will be all done in
minutes. Knowledge-wise, using JTAG is even more trivial than using the
debugger techniques to get to my data, you just need some HW skills.

Of course, this is unless you also have the JTAG somehow vendor-locked,
but then, personally, I consider it as an utter evil. For a person who
really interested in my data, attaching to a flash directly is also not
a problem (the imaginary thief already soldered JTAG and if it didn't
work, soldering a few more wires is not a big deal).

Maybe I'm paranoid here, but for me it is hard to believe that the
reduced set was not considered as a "feature" to make life more
difficult for normal users wanting their device rooted. According to
copyright dates, the FIQ debugger started very early, in 2008, when
most Android phone vendors were very unfriendly to hackers.

Btw, why do the lovely vendors allow me to use an external SD card on
the phone? My data is not protected, but the vendors suddenly no longer
care. So what changed between my data on the external SD card and in the
phone itself? Nothing. Vendors care about the root access itself, not my
data.

Really, I tend to care more about my naked pictures^W^W^W NDA documents
I should not have taken out of the office^W^W^W^W^W loads of private data
on the SD card, and less about my email password stored in phone's
memory. That's because if SD card is stolen/lost, everyone can read it,
any time. And if password is stolen, I have some time to change it.

All I see is a very artful way to sell shackles to naive people, and
this is exactly what phone vendors do by locking their devices. If I
want my data protected, I use encryption with *my* keys, I don't want
to be "protected" by the ways described above.

And the KDB lock doesn't help in a way that thieves no longer need to
disassemble the phone to erase all the data and resell the phone (if
serial port is available outside). A guy who bought the stolen phone
on eBay will never know that the phone was disassembled: only a
professional can tell whether warranty seals are original. The thief
would probably not even bother with restoring the seals, he can always
say that the phone needed a screen replacement. (Now someone might be
wondering why do I know so much about phones' black market... :-)

Still, I'm not saying that the feature is not useful at all, it is
useful. But to me, it is much more useful for public PCs/ATMs, when
a few keystrokes on a panicked ATM can open ATM's money depository.
Or just administrator don't like when wise kids get root (yup) on
classroom's PCs.

But if you say that it wasn't the case, and no one thought about the
reducing the debugger in the "evil" way, so be it, I trust you. But I
still don't trust the phone vendors. They showed their bad attitude
in many ways towards hackers, so I think we both have quite legitimate
reasons to be a little bit paranoid. :-)

> An alternate option would be to allow userspace to write a password
> hash to a sysfs file, and require the password to be entered over the
> serial console to unlock KGDB or enable unsafe KGDB commands.

Yup, that's a very nice idea. This can be implemented by introducing
"unlock" KDB command. Although, that also requires tight integration
w/ user-space, i.e. on boot userland would need to supply hashing
method, salt and root's password hash. The same has to be done on every
password change. It is surely doable, but not sure if it is worth the
efforts. Maybe, some day.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
