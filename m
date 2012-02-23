Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2BWBHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 20:07:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53439 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab2BWBHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 20:07:07 -0500
Message-ID: <4F459109.1060205@zytor.com>
Date: Wed, 22 Feb 2012 17:06:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Roland McGrath <mcgrathr@google.com>
CC: Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        Andrew Lutomirski <luto@mit.edu>, Indan Zupancic <indan@nul.nu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org
Subject: Re: [PATCH v10 07/11] signal, x86: add SIGSYS info and make it synchronous.
References: <1329845435-2313-1-git-send-email-wad@chromium.org> <1329845435-2313-7-git-send-email-wad@chromium.org> <9edbabb2262e3d91a7b8c75dbec03d7f.squirrel@webmail.greenhost.nl> <CABqD9hY1n9EOAKKT0r9Ev+azhBMnLMAM_FgDNe5we9upVePk_A@mail.gmail.com> <CAObL_7Gc0U2JMBQr_kbcVUJwyJq7LRfgdFr+84LR=ec4kSCwEA@mail.gmail.com> <CAGXu5jJQrnkCZtcLqK8NEihRgB25C12b0nKp+XWXV_=4QfcVoA@mail.gmail.com> <CABqD9hbC8v-rUBW+4T_-EwDwe1+VDohQZweQ-cxOg2A-iDH5CQ@mail.gmail.com> <CAGXu5j+fQqkrrKSm3kmCkCcZJKo-VZjL6kkrOD81LZYBY7tf2g@mail.gmail.com> <4F45887A.5010809@zytor.com> <CAB=4xhq1sm_ewZ_8Kerf2aN7nGx+DEENse7Lqg5N0wuvqtzUAw@mail.gmail.com>
In-Reply-To: <CAB=4xhq1sm_ewZ_8Kerf2aN7nGx+DEENse7Lqg5N0wuvqtzUAw@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 04:50 PM, Roland McGrath wrote:
> On Wed, Feb 22, 2012 at 4:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Can we really introduce force-kill semantics for a POSIX-defined signal?
>> Other user space programs might use it for other purposes.
> 
> The semantics are based on how the signal was generated, not what signal
> number it was.  The only thing that depends on the signal number is
> SYNCHRONOUS_MASK, which just determines in which order pending signals are
> dequeued (POSIX says it may be any order).  We only have that so your state
> doesn't get unhelpfully warped to another signal handler entry point
> (including fiddling the stack) before you dump core.
> 
> No use of SIGSYS is specified by POSIX at all, of course, since "system
> call" is an implementation concept below the level POSIX specifies.

I meant whether or not a signal can be blocked/caught and the fact that
the signal exists at all.

Now I guess we could have "blockable" and "unblockable" SIGSYS, but that
would seem to have its own set of issues...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

