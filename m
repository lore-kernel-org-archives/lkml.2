Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2E3DKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 23:10:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60815 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab2E3DKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 23:10:39 -0400
Message-ID: <4FC58EFE.2070705@zytor.com>
Date: Tue, 29 May 2012 20:07:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 trampoline rework for 3.5
References: <201205292325.q4TNPBPw007366@terminus.zytor.com> <CA+55aFyjcbaRcK5yfi-xLc2W+AAk0EAY9fhNOc+-_uQdDzck6w@mail.gmail.com>
In-Reply-To: <CA+55aFyjcbaRcK5yfi-xLc2W+AAk0EAY9fhNOc+-_uQdDzck6w@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 07:37 PM, Linus Torvalds wrote:
> 
> but in your branch that "^pa_" pattern is duplicated for S_REL:
> 
>  /*
>   * These symbols are known to be relative, even if the linker marks them
>   * as absolute (typically defined outside any section in the linker script.)
>   */
>         [S_REL] =
>         "^pa_",
> 
>  /*
>   * These are 16-bit segment symbols when compiling 16-bit code.
>   */
>         [S_SEG] =
>         "^real_mode_seg$",
> 
>  /*
>   * These are offsets belonging to segments, as opposed to linear addresses,
>   * when compiling 16-bit code.
>   */
>         [S_LIN] =
>         "^pa_",
> 
> which looks odd.
> 
> But that case with three patterns is the one you selected in your
> merge - *not* the current state of relocs.c that you claim should be
> selected.
> 

Sorry, you're right.  The version with three patterns is correct.  The
"^pa_" patterns are linear addresses which should be treated as
relative, and so belong both to S_REL and S_LIN.  This didn't surface as
a conflict, so I forgot to flag it.

> So I'm not pulling or merging anything until I understand what's going
> on. Should I take the two-pattern one (which is what I have now, and
> that seems sensible), or should that "^pa_" pattern really be merged
> for two different cases (doesn't that just mean that the last one will
> effectively override the first one)?
> 
> Also, your branch adds an "x86-relocs" thing to the scripts/.gitignore
> file that you seem to have removed in the merge. What was going on
> there?

That line should have been removed in checkin f2604c14 but wasn't; since
that was one of the checkins that got folded up into 6520fe55 I cleaned
it up at that time.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

