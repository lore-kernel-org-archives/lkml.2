Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0GZWrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:47:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47417 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab0GZWrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:47:22 -0400
MIME-Version: 1.0
In-Reply-To: <20100726221717.GA22439@merkur.ravnborg.org>
References: <20100720043706.3813715a.sfr@canb.auug.org.au> 
	<20100726221717.GA22439@merkur.ravnborg.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 26 Jul 2010 16:47:01 -0600
X-Google-Sender-Auth: j4_RigTTwgX_yUxr3AuasIrw8dg
Message-ID: <AANLkTikP3nZd-LionO27vsinjXz=upKbDZeErSD4CAfz@mail.gmail.com>
Subject: Re: [RFC][PATCH] kconfig: implement select with values
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
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
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Mon, Jul 26, 2010 at 4:17 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Tue, Jul 20, 2010 at 04:37:06AM +1000, Stephen Rothwell wrote:
>> This is a fairly brute force approach to allowing a Kconfig "select"
>> to specify an excplicit value for the selected config sybmol.
>>
>> The syntax of select is changed to:
>>
>>       "select" <symbol> [<expr>] ["if" expr]
>>
>> The approach taken is to add a list of <value, dependency expression>
>> pairs to the symbol and check them whenever the reverse depends (from
>> a current-style select) are checked.
>
> I do not see the need for this feature.
> I have read most of the postings in the defconfig battle and
> I saw Linus' select suggestion.
>
> But we can do almost all of this today (or tomorrow).
>
> Consider following Kconfig file:
>
>    config USB_SUPPORT
>            def_bool n
>
>    config NET
>            def_bool y
>
>    source arch/x86/Kconfig
>
> We use the feature that we can specify the same
> config option several times.
> And the first default value that is "visible"
> will be used.
>
> So it allows us to enable and disable any option.
>
> And if we for example want to set a specific LOG_BUF_SHIFT
> we use the same trick:
>
>    config LOG_BUF_SHIFT
>            int
>            default 14

Cute.  I didn't know this was possible.  I'll give it a try and see
how it works for me.  Do override config options also pickup
select/depends constraints applied by later definitions?  I think that
would be necessary to kick out warnings when a defconfig selection
isn't actually achievable.

g.

>
>
> Now in the original suggestion of Linus he used:
>
>    KBUILD_KCONFIG=Mykconfig make allnoconfig
>
> And "allnoconfig" would make the modified defaults useless.
>
> But the soon-to-be-introduced alldefconfig is more sensible.
>
> alldefconfig uses default values for everything.

I basically used defconfig in the prototype that I posted.  I think it
works well for me, and I've got it integrated into the build targets
(just like Stephen's earlier patch) without having to do a
KBUILD_KCONFIG trick.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
