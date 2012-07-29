Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2G2Umo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:42:44 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:10907 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2G2Umm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:42:42 -0400
Date: Sun, 29 Jul 2012 22:42:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/build change for v3.6
Message-ID: <20120729204240.GA26530@merkur.ravnborg.org>
References: <20120722134451.GA7099@gmail.com> <20120722135807.GA17513@shutemov.name> <20120722142204.GA9085@gmail.com> <20120725201511.GA888@merkur.ravnborg.org> <20120726065506.GA8421@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120726065506.GA8421@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 08:55:06AM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > 
> > > No, the reason for the odd looking diff is that lots of lines in 
> > > arch/x86/Makefile have 8-space tabs for histerical reasons but 
> > > new code (such as this one) has proper tabs.
> > 
> > Use of tabs for indent in a Makefile is just asking for 
> > trouble.
> 
> Ok, I guess you are right - see the patch below which was 
> another type of bug that could be introduced via not using 
> spaces properly.
> 
> We could do it the other way around: turn all tabs into spaces 
> and add Makefile checking in kbuild so that the build fails if
> a tab is added to a Makefile?
> 
> Alternatively, is there perhaps some way to teach make to not be 
> so broken to depend on whitespace details that are *invisible* 
> to humans?
We can teach make to use something else - say "€" - as the command idicator.
But that would confuse people a lot.

If we follow hpa's suggestion to use 4 spaces as indent then it
more obvious that we do not use tabs for indent.
For that matter we could consider 3 spaces - so two indents is not
the same as one tab.

If we one day use a tool for parsing up all the kbuild files
then we could always add checks in that tool.
but today make does not allow us to do so.

At least not that I know.

	Sam
