Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab1CJJFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:05:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44958 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1CJJFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:05:12 -0500
Date: Thu, 10 Mar 2011 10:04:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, bp@amd64.org
Subject: Re: [PATCH -v5] kbuild: Add extra gcc checks
Message-ID: <20110310090444.GA25522@elte.hu>
References: <20110301083529.GA767@liondog.tnic>
 <20110309144504.GA1096@sepie.suse.cz>
 <20110309151134.GA15730@elte.hu>
 <20110309175625.GA29181@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309175625.GA29181@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > Another, related, very nice kbuild feature would be to allow for arch maintainers to 
> > mark certain files as "should only build fine without warnings" - i.e. -Werror 
> > should be the default. There would be a Kconfig feature to opt out of this, 
> > CONFIG_CC_IGNORE_WARNINGS=y or so. This would allow for people to still build the 
> > kernel with old (or buggy) versions of GCC.
> 
> To add -Werror for all files conditionally you can do:
> 
>     ccflags-$(CONFIG_WERROR) += -Werror
> 
> For individual files we can then drop -Werror like this:
> 
>     CFLAGS_REMOVE_foobar.o := -Werror
> 
> So it should be doable with the existing infrastructure.

Stupid question: is there an existing kbuild rule that i could use to enable -Werror 
for a single .o file, such as kernel/sched.o - without affecting other files in 
kernel/ that i do not maintain?

Also, adding 3 lines per object file is pretty ugly - would it be possible to create 
a nicer, compact, single-line way to someone condense a CONFIG_ERROR opt-out 
mechanism, the -Werror default and the single-object-file into a single rule?

Something like:

  obj-werror-y += sched.o

Although i'm not sure if it is wise to mix build details into the object build tree 
hierarchy like that ...

Maybe we can live with some multi-line definition after all - until all of the 
kernel is covered by such a mechanism. But the per object file rule would still be 
important, for multi-maintainenace-boundaries directories like kernel/*.o.

Thanks,

	Ingo
