Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab1CIPLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:11:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58796 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1CIPLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:11:49 -0500
Date: Wed, 9 Mar 2011 16:11:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Marek <mmarek@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>, Arnd Bergmann <arnd@arndb.de>,
        Sam Ravnborg <sam@ravnborg.org>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, bp@amd64.org
Subject: Re: [PATCH -v5] kbuild: Add extra gcc checks
Message-ID: <20110309151134.GA15730@elte.hu>
References: <20110301083529.GA767@liondog.tnic>
 <20110309144504.GA1096@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309144504.GA1096@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Marek <mmarek@suse.cz> wrote:

> On Tue, Mar 01, 2011 at 09:35:29AM +0100, Borislav Petkov wrote:
> > Add a 'W=1' Makefile switch which adds additional checking per build
> > object.
> > 
> > The idea behind this option is targeted at developers who, in the
> > process of writing their code, want to do the occasional
> > 
> > make W=1 [target.o]
> > 
> > and let gcc do more extensive code checking for them. Then, they
> > could eyeball the output for valid gcc warnings about various
> > bugs/discrepancies which are not reported during the normal build
> > process.
> > 
> > For more background information and a use case, read through this
> > thread: http://marc.info/?l=kernel-janitors&m=129802065918147&w=2
> > 
> > -v5: Document internal kbuild variable which is introduced by this.
> > Simplify assignment.
> 
> Thanks, applied to kbuild-2.6.git#packaging. If someone comes up with a
> good selection of warnings for W=1 and W=2, we can change it later.

Another, related, very nice kbuild feature would be to allow for arch maintainers to 
mark certain files as "should only build fine without warnings" - i.e. -Werror 
should be the default. There would be a Kconfig feature to opt out of this, 
CONFIG_CC_IGNORE_WARNINGS=y or so. This would allow for people to still build the 
kernel with old (or buggy) versions of GCC.

arch/x86/ would start using this by gradually marking more and more files as -Werror 
by default. Some architectures like arch/sparc/ and arch/powerpc/ already build with 
-Werror enabled - but for arch/x86/ we cannot force this (we cannot break the build 
for who knows how many people) so we want to do it gradually and with a way out for 
users with buggy compilers.

Thanks,

	Ingo
