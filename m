Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab1IFVgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 17:36:37 -0400
Received: from ka.mail.enyo.de ([87.106.162.201]:45719 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab1IFVgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 17:36:31 -0400
X-Greylist: delayed 3357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Sep 2011 17:36:31 EDT
From: Florian Weimer <fw@deneb.enyo.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com>
	<CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
	<4E582EAA.1040108@zytor.com>
	<CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
	<CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
Date: Tue, 06 Sep 2011 22:40:21 +0200
In-Reply-To: <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 26 Aug 2011 17:43:40 -0700")
Message-ID: <877h5lh0ay.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds:

> On Fri, Aug 26, 2011 at 5:36 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> There is *ZERO* reason to not use it. Use the standard 64-bit
>> structure layout. Why the hell would it be a new system call?
>
> Oh, I see why you do that. It's because our 64-bit 'struct stat' uses
> "unsigned long" etc.
>
> Just fix that. Make it use __u64 instead of "unsigned long", and
> everything should "just work". The 64-bit kernel will not change any
> ABI, and when you compile your new ia32 model, it will do the right
> thing too.

And even if you don't want to do that (probably somebody wants to
recompile broken applications, same rationale as for n32, see
<http://gcc.gnu.org/ml/gcc/2011-02/msg00243.html>), you can still do
the translation in user space.  Then tools like strace and valgrind
just work, and you don't risk introducing kernel vulnerabilities
through broken translation code.
