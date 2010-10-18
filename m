Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab0JRTgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:36:00 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40099 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab0JRTf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:35:59 -0400
Date: Mon, 18 Oct 2010 21:35:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [RFC] better fix? (was: Re: [PATCH][GIT PULL] ftrace: Remove
	recursion between recordmcount and scripts/mod/empty)
Message-ID: <20101018193556.GA10147@merkur.ravnborg.org>
References: <1287427989.16971.304.camel@gandalf.stny.rr.com> <1287429206.16971.325.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287429206.16971.325.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 03:13:26PM -0400, Steven Rostedt wrote:
> On Mon, 2010-10-18 at 14:53 -0400, Steven Rostedt wrote:
> 
> Just calling attention to this...
> 
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index 4db60b2..9f2d5b4 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -210,7 +210,11 @@ endif
> >  
> >  ifdef CONFIG_FTRACE_MCOUNT_RECORD
> >  ifdef BUILD_C_RECORDMCOUNT
> > -cmd_record_mcount = $(objtree)/scripts/recordmcount "$(@)";
> > +# Due to recursion, we must skip the empty.o file
> > +#  TBD: Find a better way to do this.
> > +cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then			\
> > +			$(objtree)/scripts/recordmcount "$(@)";			\
> > +		    fi;
> >  else
> >  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> >  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
> > 
> 
> This is pretty much a hack, would adding a patch like the following be a
> better idea?

I prefer the hack above...
It is obvious what it does. And the hack is simple.

An additional comment about the origin of empty.o is needed.
Only very few people knows that we generate empty.o in scripts/

	Sam
