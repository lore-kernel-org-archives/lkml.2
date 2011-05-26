Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab1EZSfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:35:23 -0400
Received: from mail.lang.hm ([64.81.33.126]:37966 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523Ab1EZSfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:35:22 -0400
Date: Thu, 26 May 2011 11:34:16 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Will Drewry <wad@chromium.org>, Colin Walters <walters@verbum.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
In-Reply-To: <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105261133100.4413@asgard.lang.hm>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com> <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com> <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <20110525191152.GC19633@outflux.net> <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
 <BANLkTinZYk8YPSxwhuRePo=TdmM45qkgKw@mail.gmail.com> <BANLkTi=s09aAqiOzgAJByqZvhQLaCmEErQ@mail.gmail.com> <BANLkTik0Np23G3SjgZw3NYBG5DCFdmH+Rw@mail.gmail.com> <BANLkTi=VQEbB1CdS2w03q38d0YSc+_WYgg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Linus Torvalds wrote:
> 
> On Thu, May 26, 2011 at 9:33 AM, Will Drewry <wad@chromium.org> wrote:
>>
>> FWIW, none of the patches deal with privilege escalation via setuid
>> files or file capabilities.
>
> That is NOT AT ALL what I'm talking about.
>
> I'm talking about the "setuid()" system call (and all its cousins:
> setgit/setreuid etc). And the whole thread has been about filtering
> system calls, no?
>
> Do a google code search for setuid.
>
> In good code, it will look something like
>
>  uid = getuid();
>
>  if (setuid(uid)) {
>    fprintf(stderr, "Unable to drop provileges\n");
>    exit(1);
>  }
>
> but I guarantee you that there are cases where people just blindly
> drop privileges. google code search found me at least the "heirloom"
> source code doing exactly that.

I believe that sendmail had this exact vunerability when capibilities were 
used to control setuid a couple of years ago.

David Lang
