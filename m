Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab0G2PFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:05:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0G2PFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:05:48 -0400
Message-ID: <4C519899.9020206@suse.cz>
Date: Thu, 29 Jul 2010 17:04:57 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Aristeu Rozanski <aris@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <20100729081316.GA4990@merkur.ravnborg.org> <4C5148A5.10809@suse.cz> <20100729144748.GI6249@redhat.com>
In-Reply-To: <20100729144748.GI6249@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.7.2010 16:47, Aristeu Rozanski wrote:
> On Thu, Jul 29, 2010 at 11:23:49AM +0200, Michal Marek wrote:
>> On 29.7.2010 10:13, Sam Ravnborg wrote:
>>> On Wed, Jul 28, 2010 at 10:36:22PM +0200, Sam Ravnborg wrote:
>>>> Hi Michal.
>>>>
>>>> I cooked up the following to introduce long options in conf.
>>>> But in the process I dropped the short options. Is this OK?
>>>
>>> On top of this patch I did another two.
>>> They fixup the *nonint_oldconfig targets:
>>>
>>> nonint_oldconfig:
>>> - renamed to listnewconfig
>>> - print new options to stdout (to better support redirect)
>>> - no longer saves a new configuration
>>> - does ot exist with a failure code if there is new options
> but this kills its usefulness. nonint_oldconfig is used so you can script
> the use of a generated configuration (think distro kernel RPMs). if something
> is not set, it fails listing what's not set. otherwise it'll save the
> configuration and whatever script is using it can proceed.
> "listnewconfig" is a new, different target to me.

How about
new=$(make listnewconfig)
if test -n "$new"; then
    echo "Please set the following options:" >&2
    echo "$new" >&2
    exit 1
fi
? Wouldn't that be the same as nonint_oldconfig before?

Michal
