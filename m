Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1FCNRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:17:32 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57544 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab1FCNRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:17:31 -0400
Date: Fri, 3 Jun 2011 15:17:29 +0200
From: Andreas Mohr <andi@lisas.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Andreas Mohr <andi@lisas.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        Waldo Bastian <bastian@kde.org>, Ryan Lortie <desrt@desrt.ca>,
        Lennart Poettering <lennart@poettering.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Heads-up: Linux make menuconfig .config vs. XDG_CONFIG_HOME
 ~/.config/ clash - perhaps resolve it while 3.0 appears?
Message-ID: <20110603131729.GA27156@rhlx01.hs-esslingen.de>
References: <20110602182431.GA26282@rhlx01.hs-esslingen.de>
 <4DE89A8A.8070405@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE89A8A.8070405@suse.cz>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 10:25:46AM +0200, Michal Marek wrote:
> On 2.6.2011 20:24, Andreas Mohr wrote:
> >I just discovered a Linux kernel make menuconfig .config file
> >accidentally situated in the home directory of a shell account
> > [...]
> >"$XDG_CONFIG_HOME defines the base directory relative to which user
> >specific configuration files should be stored. If $XDG_CONFIG_HOME is
> >either not set or empty, a default equal to $HOME/.config should be
> >used."
> 
> PEBKAC :-). BTW, did you really run into such problem yourself, or
> is it more a "what if"?

"Yes and no." ;)
I did have that file sitting where it should better never have ended up
given its naming, thus I obviously did not have any .config/ directory there
at all (as opposed to a usual installation where .config/ already contains
many entries).
I had started by actively searching for contents of the .config/ dir there,
then found that there's only a .config _file_, which made me realize
that this can be very problematic.
It's unknown to me whether any friendly bits have already actually been hurt
by this problem - unless an app complains loudly, the only thing
one might perhaps notice is strange behaviour of various apps.


It's just that I feel that this is quite a major naming clash.

 
> >It may thus be strongly advisable to rename the default name of the
> >make menuconfig kernel .config file (perhaps .config_lx / .config_linux ?)
> >to completely sidestep such a (mostly user-triggered)
> >problematic clash in future.
> 
> No. The name ".config" is documented in the linux source as well as
> so many howtos and books, that we should not change it just for the
> fun of it. Arguably, a non-dot filename might have been a better
> choice, but ".config" has been chosen, so we have to live with it.

So we'll have to live with that on the other side (i.e., XDG) as well?
(which, I'm sure, will have its $HOME/.config/ directory documented in
_even more_ application-side documentation prints than the Linux
kernel .config file).
The nature of clashes is just that - it's a problematic clash,
thus it may be very helpful to devise a cleanly implementable
(read: backwards-compatible and such) exit strategy.

A change from .config to e.g. .config_linux would not be such a foreign
thing, given that it wwould be found at the very same place as the old name
in most file-manager-type situations (thus RL people wouldn't be left
wondering for all that long). One actual source of concern would be
existing scripts which by their nature currently make use of a hard-coded lookup
on ".config", as opposed to manual human action which would easily take note
of the .config_linux file.



To put forward a deeper analysis:
I guess the rationale for choosing an XDG ".config/" was to be the
singular remaining place for configuration items within a user's home
dir. Thus there's no need (nor even desire!)
to have any naming that's more specific than ".config",
since this mechanism is supposed to be as generic as it can get.

For the case of the naming of the Linux kernel configuration file?
- not so much, I'd say.
The main remaining justification for this overly generic name is
that it's supposed to sit in its own isolated kernel source dir,
and that as long as this is the case it's not conflict-prone.

Thus quite obviously I followed neither the letter of the law, nor agreed
conventions, nor all unspoken rules and conditions,
by copying the file to a _default_ place where it shouldn't end up. ;)
[and thus I'll incur the terminal wrath of all configuration gatekeepers]



Just to mention this here as well: of course it might be more suitable
to choose a filename which is using the usual *.conf extension recommendation.


> Linus made it clear that 3.0 is just a change in versioning, not an
> excuse for doing incompatible changes. (Incompatible changes can
> possibly happen in any release, but they need to be justified and
> need to be ready *before* -rc1.)

Absolutely fine with that (I was even quite astonished myself about that
relatively ad-hoc numbering change).
It just occurred to me that it might be worth mentioning this
as an appropriate moment to be doing this change in addition
to the version change.

Thanks,

Andreas Mohr
