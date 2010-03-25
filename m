Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0CYOXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:23:38 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:37737 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751234Ab0CYOXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:23:36 -0400
Date: Thu, 25 Mar 2010 10:23:33 -0400 (EDT)
From: John Kacur <jkacur@redhat.com>
To: rostedt@goodmis.org
Cc: lkml <linux-kernel@vger.kernel.org>, Clark Williams <williams@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>
Message-ID: <1709186929.883731269527013185.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1269523868.2957.4060.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] trace-cmd: Add BUILDING and INSTALL instructions to
 README
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Steven Rostedt" <rostedt@goodmis.org> wrote:

> On Thu, 2010-03-25 at 10:24 +0100, John Kacur wrote:
> > - Add BUILDING and INSTALL instructions to the README
> > - Change Makefile so that messages don't appear like errors.
> 
> Thanks,
> 
> Did you rebase your repo or do I need to pull in the other patches
> from
> the mbox?

I rebased the repo and did a push -f

> 
> One comment below.
> 
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> > ---
> >  Makefile |    6 +++---
> >  README   |   26 ++++++++++++++++++++++++++
> >  2 files changed, 29 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 8a3f25c..04fe380 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -373,10 +373,10 @@ ifneq ($(dep_includes),)
> >  endif
> >  
> >  show_gui_make:
> > -	@echo "*** to build the gui, type \"make gui\" ***"
> > +	@echo "Note: to build the gui, type \"make gui\""
> >  
> >  show_gui_done:
> > -	@echo "*** gui build complete ***"
> > +	@echo "gui build complete"
> >  
> >  PHONY += show_gui_make
> >  
> > @@ -397,7 +397,7 @@ install_cmd: all_cmd install_plugins
> >  	$(INSTALL) trace-cmd '$(bindir_SQ)'
> >  
> >  install: install_cmd
> > -	@echo "*** to install the gui, type \"make install_gui\" ***"
> > +	@echo "Note: to install the gui, type \"make install_gui\""
> >  
> >  install_gui: install_cmd gui
> >  	$(INSTALL) -d -m 755 '$(bindir_SQ)'
> > diff --git a/README b/README
> > index 7ac4390..d191197 100644
> > --- a/README
> > +++ b/README
> > @@ -9,3 +9,29 @@ These files also make up the code to create the
> libraries
> >  The applications are licensed under the GNU General Public License
> 2.0
> >  (see COPYING) and the libraries are licensed under the GNU
> >  Lesser General Public License 2.1 (See COPYING.LIB).
> > +
> > +BUILDING:
> > +
> > +To make trace-cmd
> > +    make
> > +
> > +To make the gui
> > +    make gui
> > +
> > +INSTALL:
> > +
> > +To install trace-cmd
> > +    make install
> > +
> > +To install the gui
> > +    make install_gui
> > +
> > +Note: The default install is relative to /usr/local
> > +    The default install directory is /usr/local/bin
> > +    The default plugin directory is
> /usr/local/share/trace-cmd/plugins
> > +
> > +To change the default, you can set 'prefix', eg
> > +mkdir $HOME/test-trace
> > +make prefix=$HOME/test-trace
> > +make prefix=$HOME/test-trace install
> 
> Looks good, but I would use the example of this:
> 
> make prefix=~
> make prefix=~ install
> 
> The above would install the executables into your home directory
> ~/bin
> and the plugins into ~/.trace-cmd/plugins
> 


That is an oddity, I tried to show a general case.
We could append more info about that special case if you wish.
