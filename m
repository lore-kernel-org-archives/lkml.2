Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0GZWRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:17:23 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59167 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0GZWRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:17:21 -0400
Date: Tue, 27 Jul 2010 00:17:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Francis Galiegue <fgaliegue@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Vadim Bendebury <vbendeb@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Cheng Renquan <crquan@gmail.com>, Trevor Keith <tsrk@tsrk.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC][PATCH] kconfig: implement select with values
Message-ID: <20100726221717.GA22439@merkur.ravnborg.org>
References: <20100720043706.3813715a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720043706.3813715a.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 04:37:06AM +1000, Stephen Rothwell wrote:
> This is a fairly brute force approach to allowing a Kconfig "select"
> to specify an excplicit value for the selected config sybmol.
> 
> The syntax of select is changed to:
> 
> 	"select" <symbol> [<expr>] ["if" expr]
> 
> The approach taken is to add a list of <value, dependency expression>
> pairs to the symbol and check them whenever the reverse depends (from
> a current-style select) are checked.

I do not see the need for this feature.
I have read most of the postings in the defconfig battle and
I saw Linus' select suggestion.

But we can do almost all of this today (or tomorrow).

Consider following Kconfig file:

    config USB_SUPPORT
            def_bool n

    config NET
            def_bool y

    source arch/x86/Kconfig

We use the feature that we can specify the same
config option several times.
And the first default value that is "visible"
will be used.

So it allows us to enable and disable any option.

And if we for example want to set a specific LOG_BUF_SHIFT
we use the same trick:

    config LOG_BUF_SHIFT
            int
            default 14


Now in the original suggestion of Linus he used:

    KBUILD_KCONFIG=Mykconfig make allnoconfig

And "allnoconfig" would make the modified defaults useless.

But the soon-to-be-introduced alldefconfig is more sensible.

alldefconfig uses default values for everything.

So with alldefconfig I think we have all the features we need
to create sensible default configs in the Kconfig language.

And therefore I do not see the need for the extension to select.
For the same reason I did not look closer at the implementation.

	Sam

