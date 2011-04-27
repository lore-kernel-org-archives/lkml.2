Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab1D0LfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:35:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33594 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab1D0LfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:35:06 -0400
Date: Wed, 27 Apr 2011 13:35:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3.1] kbuild: implement several W= levels
Message-ID: <20110427113513.GB18112@eferding.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
References: <20110422110947.GA20715@merkur.ravnborg.org>
 <1303494642-18594-1-git-send-email-bp@alien8.de>
 <20110427082555.GC5726@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110427082555.GC5726@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:25:55AM +0200, Sam Ravnborg wrote:
> > - make the W= levels exclusive
> I do not see the point in this really. This is not what most people would
> expect.
> When you ask for more you get more - not something else.
> 
> We see it with verbose levels where -vv give more output than -v etc.
> 
> Anyway - the important thing is to keep the relevant warnings at W=1 level.
> Which is independendt of this change.
> So consider the input and decide - I do not want to make a fuzz about it.

I know, -vv.. increases verbosity is probably part of old unix tradition
or common sense but it doesn't make much sense in this case, IMHO. When
I use this, I want to see what the most relevant warnings are, maybe
have a crack at them to fix them, and _then_ look at the less important
ones (for an arbitrary definition of important warnings).

If we do this inclusive, then W=2 dumps the, let's call it, level 1
_plus_ the new level 2 warnings, polluting the output with something
I've already seen, but only partially. And then I start to think, did
I see this one already, didn't I, which was it? By the time you enable
W=3, the output becomes pretty useless. For example, W=3 generates 190+
MB logfile here only with level 3 warnings. Now imagine all 3 levels
combined.

Dividing the output by level of importance doesn't have this problem and
is much more workable, IMHO.

But this is just my use case, it could be that I'm completely alone on
this one. I'd love to hear what other people think.

FWIW, we might even make this behavior configurable by having

make W=1o

meaning level 1 warnings only or whatever sick idea we come up with
eventually.

;-)

Thanks.

-- 
Regards/Gruss,
Boris.
