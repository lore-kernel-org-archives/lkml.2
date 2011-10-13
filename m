Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1JMGTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:19:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35893 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1JMGTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:19:38 -0400
MIME-Version: 1.0
In-Reply-To: <4E947BC9.7040805@mit.edu>
References: <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
 <CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
 <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
 <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
 <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
 <CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com>
 <CAObL_7HUhxsOVHYFovgxYu7r5YNju+n4Q45GZ9viCCW-GrxWhg@mail.gmail.com>
 <CAFLxGvx0QMrvG_ZsFE6C_xHn9JpWJ-aW-V=K9pm3OoXZc=NKxQ@mail.gmail.com>
 <20111010114840.GC17079@elte.hu> <CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com>
 <20111011062253.GA3589@elte.hu> <4E947BC9.7040805@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Oct 2011 18:19:16 +1200
X-Google-Sender-Auth: wHXrb9drfzKyelmYDjOOVbCPHIs
Message-ID: <CA+55aFyMXgzywjXCtS1a5F-BDu_XP4ecg3Tw7zLuawZs0QNYaw@mail.gmail.com>
Subject: Re: [RFC] fixing the UML failure root cause
To: Andrew Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 5:24 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> So here's a different approach.  It's not perfect: it always blames
> SEGV_MAPERR instead of SEGV_ACCERR.  I implemented it for vgettimeofday
> but not the other two vsyscalls.
>
> What do you think of this approach?  If it seems good, I'll finish the
> patch and submit it.

I think the approach is valid, but you should *not* do this as some
kind of crazy byte-by-byte copy_to_user() emulation.

Do the "copy tz to user mode" as individual "put_user()" calls for
tv_sec/tv_usec/timezone. IOW, there are three words being written to
user mode, not "two memcpy's".

Other than that, there doesn't seem to be anything wrong.

            Linus
