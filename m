Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1JNULG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:11:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64019 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab1JNULF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:11:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7ED+qwOgSH+WsLXvZqC83MX1Q-_1NtcgH-cPe9ghLveZg@mail.gmail.com>
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
 <CA+55aFyMXgzywjXCtS1a5F-BDu_XP4ecg3Tw7zLuawZs0QNYaw@mail.gmail.com>
 <CAObL_7HYnDVUyLA=FQ-qmuh=J=H=JOQTBMP_wt_zwzOfe9-7Hg@mail.gmail.com>
 <CA+55aFzoDi-WP-2Uq-33FAGfMPZbrsvg6_QWEKm1zczET539PQ@mail.gmail.com> <CAObL_7ED+qwOgSH+WsLXvZqC83MX1Q-_1NtcgH-cPe9ghLveZg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Oct 2011 08:10:43 +1200
X-Google-Sender-Auth: daJWu4dX38iJ4PTKxXNMdohOSdQ
Message-ID: <CA+55aFx3-F1LzVwN_gSqXcsU7uWda41bHyJxGxHNODWURu0T_g@mail.gmail.com>
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

On Fri, Oct 14, 2011 at 6:30 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> Another idea is to have a flag that asks the fault handlers to call
> force_sig_info for us.  That's just one bit of per-thread state.  Then
> the vsyscall emulation code could check access_ok, force a signal if
> access is not ok, then set the flag and do the syscall.  And maybe
> some processes would want to opt in to that mode anyway -- arguably
> EFAULT is a serious programmer error and should be dealt with more
> harshly than other syscall misuses.

Ok, so I really like that approach. I could easily see some process
saying "I want a SIGSEGV in addition to the EFAULT that I always get".

And yes, it would fix the vsyscall emulation code which could just
save the thread flag, set it, do the accesses, and restore it to the
old valud.

Please make it so,

          Linus
