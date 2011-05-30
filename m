Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1E3K5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:57:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37061 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1E3K5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:57:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=j5GMaRsLAaWmKGViA/LvZ8JTRy1YgwIG4s3JqnJA8wa+RK710VPB6WMM+25ST92sSj
         viRkgQe5FkVrPp/u98C87I7JflMnESfyaALxPRvUmRODcf/piWw16YVGn0CGJDFN46SH
         soQm1DYhPlVRpZVC9MGAwaAUP+lbWcyVfFuds=
MIME-Version: 1.0
In-Reply-To: <20110530074608.GD27557@elte.hu>
References: <cover.1306724657.git.luto@mit.edu> <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
 <20110530074608.GD27557@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 30 May 2011 06:57:22 -0400
X-Google-Sender-Auth: -HGjmhtn6NBsiN2ZWFTSmPvyikU
Message-ID: <BANLkTi=aX5un5ZPVD9u6NRJb-koFG7T=6w@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] x86-64: Emulate vsyscalls
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 3:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> There's a fair amount of code in the vsyscall page, and who knows
>> what will happen if an exploit jumps into the middle of it.  Reduce
>> the risk by replacing most of it with short magic incantations that
>> are useless if entered in the middle.  This change can be disabled
>> by CONFIG_UNSAFE_VSYSCALLS (default y).
>
> btw., please flip the default or consider removing the option
> altogether.
>
> We want to improve security and we want safe vsyscalls the default,
> and it's no good if we make it too easy for users to keep the fire
> door open all the time! :-)

I'd advocate waiting until glibc 2.14 comes out with this change:

http://sourceware.org/git/?p=glibc.git;a=commit;h=a8509ca540427502bd955f35296ff7b727c7a8a1

I want to add a warning (ratelimited to an extremely low rate) in v3
whenever any of the vsyscalls get used telling users that their legacy
code is suffering a performance impact, but it seems like bad form to
tell people to build glibc from git to avoid a regression.

The other option is to make the change unconditional for gettimeofday
and vgetcpu but leave time alone for awhile.  There's no a priori
reason why leaving vtime around is worse than vread_tsc and
vread_hpet.


--Andy
