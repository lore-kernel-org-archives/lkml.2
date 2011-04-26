Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab1DZUnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:43:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36112 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab1DZUnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:43:13 -0400
Date: Tue, 26 Apr 2011 22:43:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v3.1] kbuild: implement several W= levels
Message-ID: <20110426204307.GA15315@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
References: <20110422110947.GA20715@merkur.ravnborg.org>
 <1303494642-18594-1-git-send-email-bp@alien8.de>
 <4DB72283.5000108@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DB72283.5000108@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:52:35PM +0200, Michal Marek wrote:
> On 22.4.2011 19:50, Borislav Petkov wrote:
> > From: Sam Ravnborg <sam@ravnborg.org>
> > 
> > Building a kernel with "make W=1" produce far too much noise
> > to be usefull.
> > 
> > Divide the warning options in three groups:
> > 
> >     W=1 - warnings that may be relevant and does not occur too often
> >     W=2 - warnings that occur quite often but may still be relevant
> >     W=3 - the more obscure warnings, can most likely be ignored
> > 
> > When building init/ on my box the levels produces:
> > 
> > W=1 - 46 warnings
> > W=2 - 863 warnings
> > W=3 - 6496 warnings
> 
> I guess these numbers are not valid after your changes? Not that the
> exact numbers are important, but maybe the distribution change?

I think so too that those numbers don't mean a lot. Instead, this
feature makes more sense IMHO if you use it on a single file:

make W=1 <file.c> 2>before.log

<make your changes>

make W=1 <file.c> 2>after.log

diff -uprN before.log after.log

and you let the compiler tell you which warnings you've introduced. Then
you do the same game with W=2 and W=3.

Nice, huh. :)

-- 
Regards/Gruss,
    Boris.
