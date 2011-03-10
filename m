Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1CJJUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:20:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44993 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1CJJUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:20:39 -0500
Date: Thu, 10 Mar 2011 10:20:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, bp@amd64.org
Subject: Re: [PATCH -v5] kbuild: Add extra gcc checks
Message-ID: <20110310092034.GA21454@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
	Michal Marek <mmarek@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
	torvalds@linux-foundation.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	bp@amd64.org
References: <20110301083529.GA767@liondog.tnic>
 <20110309144504.GA1096@sepie.suse.cz>
 <20110309151134.GA15730@elte.hu>
 <20110309175625.GA29181@merkur.ravnborg.org>
 <20110310090444.GA25522@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110310090444.GA25522@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 10:04:44AM +0100, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > Another, related, very nice kbuild feature would be to allow for arch maintainers to 
> > > mark certain files as "should only build fine without warnings" - i.e. -Werror 
> > > should be the default. There would be a Kconfig feature to opt out of this, 
> > > CONFIG_CC_IGNORE_WARNINGS=y or so. This would allow for people to still build the 
> > > kernel with old (or buggy) versions of GCC.
> > 
> > To add -Werror for all files conditionally you can do:
> > 
> >     ccflags-$(CONFIG_WERROR) += -Werror
> > 
> > For individual files we can then drop -Werror like this:
> > 
> >     CFLAGS_REMOVE_foobar.o := -Werror
> > 
> > So it should be doable with the existing infrastructure.
> 
> Stupid question: is there an existing kbuild rule that i could use to enable -Werror 
> for a single .o file, such as kernel/sched.o - without affecting other files in 
> kernel/ that i do not maintain?
> 
> Also, adding 3 lines per object file is pretty ugly - would it be possible to create 
> a nicer, compact, single-line way to someone condense a CONFIG_ERROR opt-out 
> mechanism, the -Werror default and the single-object-file into a single rule?
> 
> Something like:
> 
>   obj-werror-y += sched.o

I believe you can do

CFLAGS_sched.o = -Werror

or similar but you'll have to try it out. I remember doing a more
involved per-object flags fumbling with the popcnt stuff, i.e. you might
want to take a look at d61931d89be506372d01a90d1755f6d0a9fafe2d where
we pass it an arch-specific config option so you can have per-object,
per-arch build flags :).

HTH.

-- 
Regards/Gruss,
    Boris.
