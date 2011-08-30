Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1H3BRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:17:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:34030 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab1H3BRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:17:45 -0400
Date: Mon, 29 Aug 2011 21:17:19 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
Message-ID: <20110830011719.GB8505@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <4E582577.2060805@zytor.com>
 <CA+55aFzkpt48EPdVrs3aoALXnqAwqHfUCeZOpvf874O8Y8+POQ@mail.gmail.com>
 <4E582EAA.1040108@zytor.com>
 <CA+55aFxdRMxWLh1B_8v29qFafM425uH7kbYRfqoPe3TpVwOx-w@mail.gmail.com>
 <CA+55aFyVmA_26LYaJH8dnFhwo7LWM6Ck7qFxCQvnROEHSuV_aA@mail.gmail.com>
 <4E584492.5090406@zytor.com>
 <CA+55aFw8+fkwjgAYOzxnO1HY3uCBCuf+N6z1XX2m=FhSjD5Wqg@mail.gmail.com>
 <CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXhdg6GuJqSjK5SdKBrBzZwGYus2LH1yqgkSnSEp8ZXyg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 09:01:37PM +0200, Geert Uytterhoeven wrote:
> On Sat, Aug 27, 2011 at 03:42, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > time_t really *should* be 64-bit, the same way "off_t" should be. If
> > it's not, there's something wrong.
> 
> Which will break all this non-portable 32-bit-only source code x32 was invented
> for in the first place?
> Someone will pass a time_t or off_t and an innocent pointer to a custom
> printf-alike function to format it like "%u %s" and it will go bang...

Well, for old static binaries, the old syscall ABI would still have to
use 32-bit off_t's and time_t's.  And for dynamically linked binaries,
glibc could deal with the compatibility issues with the old ABI,
across the shared library interface, right?

      	    	      	  		       	    - Ted
