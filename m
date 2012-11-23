Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030245Ab2KWHtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:49:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62898 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030181Ab2KWHtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:49:05 -0500
MIME-Version: 1.0
In-Reply-To: <20121121155208.GF22106@titan.lakedaemon.net>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkdYAnNCFDCjA67r0h_CSHMifb1Z83YJfYGQV3abPB8uQZg@mail.gmail.com>
	<50ACAAF5.2030002@gmail.com>
	<CACRpkdYzQuv8sPk57CvqiwMmV0z007cGqVkGOENmr_aYAN14=Q@mail.gmail.com>
	<20121121155208.GF22106@titan.lakedaemon.net>
Date: Fri, 23 Nov 2012 08:49:04 +0100
Message-ID: <CACRpkdYXSR7Fv95bCPSTZiUHgV+jwnVw1MraE_73njNa807wnQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Dove pinctrl fixes and DT enabling
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 4:52 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Wed, Nov 21, 2012 at 03:45:42PM +0100, Linus Walleij wrote:

>> So what I mean is that the patches creating pinctrl/mvebu is in the
>> pinctrl tree, so if patches in the MVEBU tree depend on these,
>> then it must have pulled in a branch from pinctrl or applied the
>> same patches in that tree too (which is OK *sometimes*).
>
> Yes, Thomas and Gregory informed me of the pinctrl dependency and said
> they were using for-next from the pinctrl tree.  I've used that branch
> to merge and build successfully.  Is that ok in practice or is there a
> more specific branch I should pull in as a dependency?

Do not use for-next. That is a mix-down for the linux-next tree.

It is basically created like this:

git checkout for-next
git reset --hard fixes
git merge devel

fixes will be based on the latest release candidate and devel on
something older like -rc1, -rc2.

If you pull something in it must be from the devel branch.

The ebst idea is to take the last commit in the devel branch
that you need, so the last mvebu commit in that branch.
This is what the ARM SoC guys usually does.

So: git pull <pinctrl tree> devel
git log ...
<find the commit you need e.g 10930572>
git checkout -b my-new-mvebu-stuff 10930572

So you branch off where you have the deps you
need.

That way I can still reorder patches *above* that
commit (not that I should, but sometimes we discover
commits that are not bisectable and such exceptions).

The result can the be pulled into my tree or ARM SoC
or similar.

Linus Walleij
