Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181Ab2JDOco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:32:44 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44730 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031Ab2JDOcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:32:43 -0400
Date: Thu, 4 Oct 2012 07:31:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121004143131.GA2643@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121002195042.GA16087@www.outflux.net>
 <20121003132538.GE13192@linux.vnet.ibm.com>
 <20121003161702.GA22008@kroah.com>
 <20121003164712.GF2527@linux.vnet.ibm.com>
 <20121003172142.GA5061@kroah.com>
 <20121003174606.GB637@somewhere>
 <20121003193653.GB30477@redhat.com>
 <20121003214325.GE637@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003214325.GE637@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100414-7282-0000-0000-00000D9AE9F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:43:37PM +0200, Frederic Weisbecker wrote:
> On Wed, Oct 03, 2012 at 03:36:53PM -0400, Dave Jones wrote:
> > On Wed, Oct 03, 2012 at 07:46:18PM +0200, Frederic Weisbecker wrote:
> >  > > it in the kernel tree, unless we wanted people to use the option?
> >  > 
> >  > A solution could be to add that option under CONFIG_DEBUG_KERNEL and specify
> >  > that it must only be enabled by developers for specific reasons (overhead,
> >  > security). CONFIG_PROVE_LOCKING falls into that category, right?
> >  > 
> >  > We have CONFIG_RCU_USER_QS that is a specific case. It's an intermediate state
> >  > before we implement a true CONFIG_NO_HZ_FULL. But the option is useless on its
> >  > own for users. Worse, it introduces a real overhead. OTOH we want it to be upstream
> >  > to make the development of full tickless feature more incremental.
> >  > 
> >  > Perhaps we should put that under CONFIG_DEBUG_KERNEL.
> > 
> > Overloading an existing config option for something unrelated seems unpleasant to me.
> > It will only take a few people to start doing this, before it turns into a landslide
> > where everyone ends up with DEBUG_KERNEL set.
> > And what of people who already have DEBUG_KERNEL set ?
> 
> Sorry, by wording wasn't clear. I didn't mean overloading CONFIG_DEBUG_KERNEL but
> rather depend on it.
> 
> > 
> > Just state what you wrote above in the kconfig.
> > Currently, RCU_USER_QS says nothing about the fact that it's work in progress.
> 
> Yeah I much prefer that. I'll add some details on the Kconfig.
> 
> > The missing part that I don't have an answer for however, is what happens
> > when you deem this production ready? Distro maintainers won't notice the
> > kconfig text changing. But perhaps that's a good thing, and will lead to things
> > only being enabled when people explicitly ask for them in distros.
> 
> That Kconfig option is likely going to disappear inside a new CONFIG_NO_HZ_FULL that
> will enables individual features like RCU user mode and stuffs.
> 
> And if it stays, it will be enabled by CONFIG_NO_HZ_FULL. So it's not an option
> anybody will ever have to deal with directly.
> 
> > Alternatively, if you really do want to go the path of a new config option,
> > perhaps CONFIG_NOT_DISTRO_READY would spell things out more clearly.
> > EXPERIMENTAL is such a wasteland it would take too much manpower to audit
> > every case, and update accordingly, but scorching the earth and starting
> > afresh might be feasible.
> 
> CONFIG_STAGING already does that kind of thing I guess. Although I suspect people
> are reluctant with core features in -staging.

Well, it would certainly be possible to include a file from a
drivers/staging/rcu directory or some such.  As you say, I am not sure
how Greg KH would react to such a patch, though.  ;-)

I guess that the lesson I am learning here is that the nocb patch
needs to go into the -rt patchset rather than directly into mainline.
Though Dave Jones's thought of tainting the kernel at boot time
sounds interesting as well.

							Thanx, Paul

