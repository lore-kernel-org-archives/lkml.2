Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab0JRWgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:36:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63473 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab0JRWgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uhIQ0ZYLsmCoTKM0knlMQcmHIKhWORc+8GNBH1THWJSAKZPVMpURLRDpLf8j7wnxkm
         HpWmoyWC9q8ri8ZHIjDlmJSU4av3vXAqISGr7XYB7eFQnVq+t6aOi6fdjmH9G83aFQ/H
         0cuK+9X9+bL1eEoR4dXnqbVJHhwfZfJ5BtQSg=
Date: Tue, 19 Oct 2010 00:35:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH 2/9] perf: Add ability to dump user regs
Message-ID: <20101018223539.GB5370@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> <1286946421-32202-3-git-send-regression-fweisbec@gmail.com> <1286954453.29097.58.camel@twins> <AANLkTinhGrdGyLaOGtXPktQM2uQ_0M9XQ1GjtBAYf+LY@mail.gmail.com> <20101014112000.GA5336@nowhere> <AANLkTimVPNntcSexdRnkvd+4VdGf2HU+rM7Zhyu=i7CS@mail.gmail.com> <20101015225722.GA5354@nowhere> <1287310023.1998.150.camel@laptop> <AANLkTi=Ja1Yem9Nkdz06_ZxtvxGZUPbGYqusfcf3iN-G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Ja1Yem9Nkdz06_ZxtvxGZUPbGYqusfcf3iN-G@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:01:18PM +0200, Stephane Eranian wrote:
> On Sun, Oct 17, 2010 at 12:07 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Sat, 2010-10-16 at 00:58 +0200, Frederic Weisbecker wrote:
> >> > Yes, PEBS does not capture the entire state.
> >> >
> >> > Here is what you get on Intel Core:
> >> >         u64 flags, ip;
> >> >         u64 ax, bx, cx, dx;
> >> >         u64 si, di, bp, sp;
> >> >         u64 r8,  r9,  r10, r11;
> >> >         u64 r12, r13, r14, r15;
> >
> >> Ok, that seems to cover most of the state. I guess few people care
> >> about cs, ds, es, fs, gs, most of the time.
> >
> > Yeah, except if you want to profile wine or something like that ;-)
> >
> That means that if you want the segment registers, then you cannot
> use PEBS. I think you could catch that when the event is created.
> 
> The other problem here is how to name registers at the API level.
> You would be introducing architecture-specific register names
> in perf_event.h. There is no such a thing today.


That can go into an asm/perf_regs.h or something. It's up to the
arch to name its registers.

