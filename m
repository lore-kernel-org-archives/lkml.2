Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab0KOTw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:52:57 -0500
Received: from mail.perches.com ([173.55.12.10]:1328 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758222Ab0KOTw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:52:56 -0500
Subject: Re: [PATCH 44/44] sound/soc/codecs: Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101115193407.GK12986@rakim.wolfsonmicro.main>
References: <cover.1289789604.git.joe@perches.com>
	 <97fd199b7dac50613f6843156687223928cce44a.1289789605.git.joe@perches.com>
	 <20101115134939.GC12986@rakim.wolfsonmicro.main>
	 <1289840957.16461.138.camel@Joe-Laptop>
	 <20101115173031.GI12986@rakim.wolfsonmicro.main>
	 <1289842444.16461.140.camel@Joe-Laptop>
	 <20101115182708.GJ12986@rakim.wolfsonmicro.main>
	 <1289845830.16461.149.camel@Joe-Laptop>
	 <20101115190738.GF3338@sirena.org.uk>
	 <1289848458.16461.150.camel@Joe-Laptop>
	 <20101115193407.GK12986@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 11:52:53 -0800
Message-ID: <1289850773.16461.166.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 19:34 +0000, Mark Brown wrote:
> On Mon, Nov 15, 2010 at 11:14:18AM -0800, Joe Perches wrote:
> > On Mon, 2010-11-15 at 19:07 +0000, Mark Brown wrote:
> > > I'd suggest using pattern matching to look up the
> > > rules for generating the prefixes (it's pretty much entirely prefixes)
> > > in the same way you're handling figuring out who to mail - that'd
> > > probably cover it in an automatable fashion.
> > Publish a tool that works and I'll use it.
> It appears your scripts are already hooked into get_maintainers.pl which
> would seem the obvious place to do this?  Sadly I don't do perl, though
> it looks like you're doing pretty much all the work on that anyway.

Sadly, no it's not the right place.

That script just generates cc email addresses
for pre-formatted commit patches.

It'd have to be a script that modifies the git commit subject line
to the taste of the subsystem maintainer.

Right now, I use a commit script that's something like:

#!/bin/bash
echo "$1: Remove unnecessary semicolons" > msg
echo >> msg
#cat >> msg <<EOF
#Unnecessary semicolons should not exist.
#EOF
git commit -s -F msg $1

There could be a modification to $1 (path)
or some such.

Maybe a script like
./scripts/convert_commit_subject_to_subsystem_maintainer_taste
or something.

Care to write one in sh/bash/perl/python/c/ocaml/c#?

As far as I know, the only subsystem pedants^H^H^H^H^Hople
that care much about the commit subject style are
arch/x86 and sound.

I can understand the desire of these subsystem maintainers
to have a consistent style.  I think though that requiring
a subject header style without providing more than a
general guideline is a but much.

I'd use any other automated tool you want to provide.

cheers, Joe

