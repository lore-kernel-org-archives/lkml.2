Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1BEA2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 19:28:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44175 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1BEA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 19:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=qbgV6DRuH3i4WdHn+mNodKRxynMMcb35pU2C0IMTLSitdNzVIipkIOHlrIJVdBtrLR
         KbdkiGUHb/mtO4G1rL4gG7Un3r9PbCyAyQ4s4NTE1uWc7EiQb1x0WtOAsoE6K1o6Sllp
         jngUD2m8NgW9brJC/kDjYGO8j0+riYFHPCMJQ=
Date: Sat, 5 Feb 2011 01:28:42 +0100
From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kbuild@vger.kernel.org, zippel@linux-m68k.org, mmarek@suse.cz,
        akpm@linux-foundation.org, andrea.gelmini@gelma.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python
 Kconfig parser
Message-ID: <20110205002841.GA13060@ulf>
Mail-Followup-To: Ulf Magnusson <ulfalizer.lkml@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kbuild@vger.kernel.org,
	zippel@linux-m68k.org, mmarek@suse.cz, akpm@linux-foundation.org,
	andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
References: <20110201232750.GA30800@ulf>
 <20110204143529.f49e92e5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110204143529.f49e92e5.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 02:35:29PM -0800, Randy Dunlap wrote:
> On Wed, 2 Feb 2011 00:27:55 +0100 Ulf Magnusson wrote:
> 
> > Hi,
> > 
> > This is the initial release of Kconfiglib: a Python library for
> > scripting, debugging, and extracting information from Kconfig-based
> > configuration systems.  It can be used to programmatically generate a
> > .config when the '*conf' tools are too inflexible, to quickly find out
> > interesting information about a Kconfig configuration such as dependency
> > relations between symbols and where undefined symbols are referenced,
> > and in applications that need to parse and extract information from
> > Kconfig files.
> > 
> > For a much longer introduction including multiple examples, see
> > arch/kconfig/kconfiglib.py.
> > 
> > Have fun!
> > 
> > Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
> > ---
> > Convenience links:
> > 
> > Documentation, generated from kconfiglib.py with pydoc -w:
> > http://dl.dropbox.com/u/10406197/kconfiglib.html
> > 
> > Examples as separate files:
> > http://dl.dropbox.com/u/10406197/kconfiglib-examples.tar.gz
> > 
> > 
> > The patch should be preferably be applied to a recent kernel, i.e. Linus's
> > (2.6.38-rc3 at the time of writing).  Due to recent Kconfig changes, the
> > kconfigtest.py test suite - which compares output character-for-character -
> > will indicate failure on older (a few months old) kernels versions even though
> > the outputs are functionally equivalent.
> > 
> >  Documentation/kbuild/kconfig-language.txt |    5 +
> >  Documentation/kbuild/kconfig.txt          |    8 +
> >  README                                    |   13 +
> >  scripts/kconfig/Makefile                  |   26 +-
> >  scripts/kconfig/kconfiglib.py             | 3918 +++++++++++++++++++++++++++++
> >  scripts/kconfig/kconfigtest.py            |  396 +++
> >  6 files changed, 4365 insertions(+), 1 deletions(-)
> >  create mode 100644 scripts/kconfig/kconfiglib.py
> >  create mode 100644 scripts/kconfig/kconfigtest.py
> > 
> 
> > diff --git a/README b/README
> > index 1b81d28..bb5e68f 100644
> > --- a/README
> > +++ b/README
> > @@ -196,6 +196,19 @@ CONFIGURING the kernel:
> >  			   values to 'n' as much as possible.
> >  	"make randconfig"  Create a ./.config file by setting symbol
> >  			   values to random values.
> > +	"make scriptconfig SCRIPT=<path to script>" Run a Kconfiglib
> > +			   script (see scripts/kconfig/kconfiglib.py).  This
> > +			   can be used to programatically generate a
> > +			   ./.config, and for applications that need to
> > +			   extract information from Kconfig files.
> > +	"make iscriptconfig" Launch an interactive Python shell
> > +			   for running Kconfiglib on the architecture's
> > +			   Kconfig configuration.  The kconfiglib and sys
> > +			   (for sys.argv[1] - the base Kconfig file) modules
> > +			   will be imported automatically, and a Config
> > +			   instance 'c' will be created for the architecture
> > +			   (using c = kconfiglib.Config(sys.argv[1])).
> > +
> >  
> >     You can find more information on using the Linux kernel config tools
> >     in Documentation/kbuild/kconfig.txt.
> 
> Hi Ulf,
> 
> This is interesting.  I just wish I could read it.  ;)
> I'll get over it.
> 
> 
> 1.  It would be really Good to have "make scriptconfig SCRIPT=<path to script>"
> and "make iscriptconfig" (similar to above, but shortened) in "make help" output.

I have added short descriptions to "make help", mostly referring people
to the script itself. Do you think I should explain it more fully? I
felt bad about adding big blobs of text when the "make help"
descriptions for all the other *config targets are short oneliners :)

> 
> 2.  My first test (using your ex1.py script) failed because I used O=xx64 (build
> directory):
> 
> rddunlap@chimera:lnx-2638-rc3> make O=xx64 scriptconfig SCRIPT=~/pkg/kconfiglib/ex1.py
>   GEN     /lnx/src/lnx-2638-rc3/xx64/Makefile
> Traceback (most recent call last):
>   File "/home/rddunlap/pkg/kconfiglib/ex1.py", line 1, in <module>
>     import kconfiglib
> ImportError: No module named kconfiglib
> make[2]: *** [scriptconfig] Error 1
> make[1]: *** [scriptconfig] Error 2
> make: *** [sub-make] Error 2
> 
> Does kconfiglib support O=builddir generally?  I can't tell that it does (yet)
> since all ex[1-7].py fail in this manner.
> It needs to support/allow O=builddir.

I hadn't considered O. I'll see if I can cook up a patch.

/Ulf
