Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1LGDXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:23:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50485 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1LGDXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:23:33 -0500
Date: Wed, 7 Dec 2011 03:23:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207032329.GW2203@ZenIV.linux.org.uk>
References: <4EDE94DC.8010106@canonical.com>
 <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <20111207003922.GO2203@ZenIV.linux.org.uk>
 <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk>
 <20111207013720.GS2203@ZenIV.linux.org.uk>
 <CA+55aFx7HZrZ=OxnRaCKnHJU0fYk5G7PY1o8eRBOaPZu7h-4kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx7HZrZ=OxnRaCKnHJU0fYk5G7PY1o8eRBOaPZu7h-4kA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 06:21:55PM -0800, Linus Torvalds wrote:

> Afaik, you really are trying to make crazy code continue to work in
> ways that I'm not convinced is really required. Now, maybe it's a good
> idea for this stage in the -rc process, but my gut feel is that we
> could simply have broken it too. JJ seems willing to fix things up for
> AppArmor, and I don't know of any big distro that uses Tomoyo, so...

*snort*

As far as I'm concerned, adding

# misnomer/marketing/lie - that's LSM, actually
config SECURITY
	depends on INSANITY || CRETINOUS_MANAGEMENT || SHITTY_GOV_REQS

would be a good thing; git rm on the whole bunch would be even better
(yes, both the pathname-based horrors and selinux).  Not feasible,
unfortunately - Linux S&M is there to stay.  More's the pity...

Anyway, we are at -rc4 and we have an oopsable race that needs to be fixed.
So let's fix it and then let apparmor and tomoyo folks deal with their
ugly stuff.  It's also 3.0.x / 3.1.x fodder; the same goes for 2.6.3[6-9].x
but there tomoyo part will need backporting (they had changes circa 3.0-rc3
in that area).

I don't think that d_absolute_path() is a bad thing per se - it's *definitely*
bad for making security decisions, but you've mentioned debugging yourself.
Better that than kludges like struct path root = {} and passing &root around,
especially if random debugging code starts using it...

I'm waiting an ACK/NAK for apparmor bits from John; I think the summary I've
put in the previous mail would do as commit message, so I'll put it into
commit and push in #for-linus; if John ACKs that sucker, pull request time...
