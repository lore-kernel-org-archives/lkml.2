Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0IQSgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:36:15 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:55660 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439Ab0IQSgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:36:14 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Sep 2010 14:36:14 EDT
Date: Fri, 17 Sep 2010 11:30:03 -0700
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Documentation/kbuild: major edit of modules.txt
 sections 1-4
Message-ID: <20100917183003.GA13785@haskell.muteddisk.com>
Mail-Followup-To: Michal Marek <mmarek@suse.cz>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <1284628230-910-1-git-send-email-mfm@muteddisk.com>
 <4C938A4B.4030601@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C938A4B.4030601@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:33 Fri 17 Sep     , Michal Marek wrote:
> On 16.9.2010 11:10, matt mooney wrote:
> > A couple of notes: 
> >     I chose to use the environment variable $PWD in the examples for both the commandline
> >     and Makefile; however, I was wondering if I should have set PWD in the Makefile and
> >     used $(PWD) instead.
> 
> I'd rather keep the example Makefile minimalistic.

Ok, I was planning on still using the environment variable if that is okay with
you.

> 
> > Also, the $@ variable was removed from the 'make' command within
> >     the Makefile. I did not understand the purpose of this for building kernel modules and
> >     it would break my test build.
> 
> $@ is the name of the target, so in
> 		all::
> 			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
> this translates to '$(MAKE) -C $(KERNELDIR) M=`pwd` all' which is the
> default. So with your change it does the same, but I'm surprised that
> the $@ didn't work for you.

I think we should leave this out anyway to simplify the command syntax.

> [...]
> > -	$KDIR refers to the path to the kernel source top-level directory
> > +	$KDIR is the path to the kernel source directory.
> 
> I'm not a native English speaker, but I read the new sentence as "the
> $KDIR variable holds the path to the kernel source directory, you can
> use the following commands verbatim", instead of "$KDIR is used in place
> of the path to the kernel source directory, replace it with the actual
> path".

You are right, I will reword this.

> >  
> > -	make -C $KDIR M=`pwd`
> > -		Will build the module(s) located in current directory.
> > -		All output files will be located in the same directory
> > -		as the module source.
> > -		No attempts are made to update the kernel source, and it is
> > -		a precondition that a successful make has been executed
> > -		for the kernel.
> > +	make -C $KDIR
> > +		-C is used to specify where to find the kernel source.
> > +		'make' will actually change to the specified directory
> > +		when executing and will change back when finished.
> >  
> > -	make -C $KDIR M=`pwd` modules
> > -		The modules target is implied when no target is given.
> > -		Same functionality as if no target was specified.
> > -		See description above.
> > +	make -C $KDIR M=$PWD
> > +		M= is used to tell kbuild that an external module is being
> > +		built. The option given to M= is the directory where the
> > +		external module (kbuild file) is located.
> >  
> > -	make -C $KDIR M=`pwd` modules_install
> > -		Install the external module(s).
> > -		Installation default is in /lib/modules/<kernel-version>/extra,
> > -		but may be prefixed with INSTALL_MOD_PATH - see separate
> > -		chapter.
> > +	make -C $KDIR SUBDIRS=$PWD
> > +		Same as M=. The SUBDIRS= syntax is kept for backwards
> > +		compatibility, but its usage is deprecated.
> 
> While you are rewriting the file, you can also drop the reference to
> SUBDIRS. It has been deprecated for over six years, so it doesn't need
> to be documented anymore, IMO. BTW, I like how you swapped the two
> sections, it is more logical that way.
> 
> [...]
> > -	Examples (module foo.ko, consist of bar.o, baz.o):
> > -		make -C $KDIR M=`pwd` bar.lst
> [...]
> > +		make -C $KDIR M=$PWD bar.o
> 
> make -C $KDIR M=`pwd` bar.lst was a valid command, see make help:
> 
>   dir/file.lst    - Build specified mixed source/assembly target only
>                     (requires a recent binutils and recent build
> (System.map))
> 
> Perhaps there should be a short sentence explaining what the four
> commands do.

Ah, an explanation may help.

> The rest looks OK to me (although I can't really comment on the language
> part), thanks a lot for looking into this.

I have actually reedited some of my changes.

After further review of the document, I believe some modifications might help.
First, I am thinking that the "Options" and "Targets" sections could introduce
the full command syntax and then list the individual items with an explanation.

For example:

make -C $KDIR M=$PWD

     -C
        info on the option
     M=
        ...

Next, section 3 "Example commands" seems redundant because the commands are
first explained in section 2.1. Also, section 4 seems to not be fully divided
into sections; looking at the table of contents, it does not list
sub-sections. Each example within that section, IMHO, should be an individual
section and not fall under the heading "Shared Makefile for module and kernel."
The new headings could be something like:

4.1 Shared Makefile
4.2 Kbuild file and Makefile

Backwards compatibility can be included in 4.2 if it is still needed? An
explanation that obj-m is the module being built would be nice along with a
sub-section showing how multiple modules can be built at the same time. And,
the intro in section 5 could use some serious rewording,

Besides that, the rest of the document looks good and only needs some minor
corrections, such as EXTRA_CFLAGS -> ccflags-y.

Let me know what you think.

Thanks,
matt
