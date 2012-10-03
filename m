Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab2JCVnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:43:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50161 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2JCVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:43:44 -0400
Date: Wed, 3 Oct 2012 23:43:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121003214325.GE637@somewhere>
References: <20121002195042.GA16087@www.outflux.net>
 <20121003132538.GE13192@linux.vnet.ibm.com>
 <20121003161702.GA22008@kroah.com>
 <20121003164712.GF2527@linux.vnet.ibm.com>
 <20121003172142.GA5061@kroah.com>
 <20121003174606.GB637@somewhere>
 <20121003193653.GB30477@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003193653.GB30477@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 03:36:53PM -0400, Dave Jones wrote:
> On Wed, Oct 03, 2012 at 07:46:18PM +0200, Frederic Weisbecker wrote:
>  > > it in the kernel tree, unless we wanted people to use the option?
>  > 
>  > A solution could be to add that option under CONFIG_DEBUG_KERNEL and specify
>  > that it must only be enabled by developers for specific reasons (overhead,
>  > security). CONFIG_PROVE_LOCKING falls into that category, right?
>  > 
>  > We have CONFIG_RCU_USER_QS that is a specific case. It's an intermediate state
>  > before we implement a true CONFIG_NO_HZ_FULL. But the option is useless on its
>  > own for users. Worse, it introduces a real overhead. OTOH we want it to be upstream
>  > to make the development of full tickless feature more incremental.
>  > 
>  > Perhaps we should put that under CONFIG_DEBUG_KERNEL.
> 
> Overloading an existing config option for something unrelated seems unpleasant to me.
> It will only take a few people to start doing this, before it turns into a landslide
> where everyone ends up with DEBUG_KERNEL set.
> And what of people who already have DEBUG_KERNEL set ?

Sorry, by wording wasn't clear. I didn't mean overloading CONFIG_DEBUG_KERNEL but
rather depend on it.

> 
> Just state what you wrote above in the kconfig.
> Currently, RCU_USER_QS says nothing about the fact that it's work in progress.

Yeah I much prefer that. I'll add some details on the Kconfig.

> The missing part that I don't have an answer for however, is what happens
> when you deem this production ready? Distro maintainers won't notice the
> kconfig text changing. But perhaps that's a good thing, and will lead to things
> only being enabled when people explicitly ask for them in distros.

That Kconfig option is likely going to disappear inside a new CONFIG_NO_HZ_FULL that
will enables individual features like RCU user mode and stuffs.

And if it stays, it will be enabled by CONFIG_NO_HZ_FULL. So it's not an option
anybody will ever have to deal with directly.

> Alternatively, if you really do want to go the path of a new config option,
> perhaps CONFIG_NOT_DISTRO_READY would spell things out more clearly.
> EXPERIMENTAL is such a wasteland it would take too much manpower to audit
> every case, and update accordingly, but scorching the earth and starting
> afresh might be feasible.

CONFIG_STAGING already does that kind of thing I guess. Although I suspect people
are reluctant with core features in -staging.
