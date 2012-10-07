Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2JGUTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 16:19:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab2JGUTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 16:19:12 -0400
Date: Sun, 7 Oct 2012 16:18:54 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121007201854.GA6628@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dave Airlie <airlied@gmail.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Kees Cook <keescook@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20121003164712.GF2527@linux.vnet.ibm.com>
 <CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
 <20121003200314.GR2527@linux.vnet.ibm.com>
 <20121004015539.GA19958@srcf.ucam.org>
 <20121004143150.GA2464@linux.vnet.ibm.com>
 <20121005164642.GA10711@linux.vnet.ibm.com>
 <CAFTL4hy434CQhT8WTvKmNzkO4k_isfKQOrCjgfYFYfMVgS7QDw@mail.gmail.com>
 <20121007014447.GB2485@linux.vnet.ibm.com>
 <CAPM=9tzoaZ3AWzA6MFnKAMzFgrarWW=JTLHSTzGBf0hoPQ_RmQ@mail.gmail.com>
 <20121007163029.GG2485@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007163029.GG2485@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 09:30:29AM -0700, Paul E. McKenney wrote:
 
 > > I think Kconfig is mostly what distro would like to use the thing is
 > > the Kconfig text needs to be there upfront when its merged, not two
 > > months later, since then it too late for a distro to notice.
 > > 
 > > I'd bet most distros would read the warnings, but in a lot of cases
 > > the warning don't exist until its too late.
 > 
 > In the case of CONFIG_RCU_USER_QS you are quite right, the warning
 > should have been there from the beginning and was not.  I suppose you
 > could argue that the warning was not sufficiently harsh in the case of
 > CONFIG_RCU_FAST_NO_HZ, but either way it did get ignored:

Maybe if we had a universally agreed upon tag for kconfig, like
"distro recommendation: N" that would make things obvious, and also allow
those of us unfortunate enough to maintain distro kernels to have something
to easily grep for.  This would also catch the case when you eventually (hopefully)
flip from an N to a Y.

There will likely still be some distros that will decide they know better
(and I'm pretty sure eventually I'll find reason to do so myself), but it at least
gives the feature maintainer the "I told you so" clause.

Something we do quite often for our in-development kernels is enable something
that's shiny, new and unproven, and then when we branch for a release, we turn
it back off.  It would be great if a lot of this kind of thing could be more automated.

	Dave

