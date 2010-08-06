Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300Ab0HFNye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:54:34 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:55852 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761382Ab0HFNya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:54:30 -0400
Date: Fri, 6 Aug 2010 15:54:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nir Tzachar <nir.tzachar@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nconfig: add search support
Message-ID: <20100806135429.GB25864@merkur.ravnborg.org>
References: <AANLkTimyDwWtLbc682rW-QORjU0+r+txZO-iKAini1H1@mail.gmail.com> <1280838492-9942-1-git-send-email-nir.tzachar@gmail.com> <20100805100408.5b724047.randy.dunlap@oracle.com> <AANLkTi=9hBYy4k=tJBo38O98z_O646ZpStqNdEYWP3MO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=9hBYy4k=tJBo38O98z_O646ZpStqNdEYWP3MO@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> >> Searching: pressing '/' triggers search mode. nconfig performs a
> >>            regular string compare, case insensitive, starting at
> >
> > I would say: simple string compare
> > "regular" has no meaning (at least for me) there.

pressing '/' triggers interactive search mode. nconfig search for the
string in the menu prompts (no regex support).

[Just a suggestion for a bt different wording]

> > Maybe I should just stick to config symbol searches.  I don't think it's all
> > that likely that people will know how each menu line text begins.
> >
> >
> 
> We can replace strcasecmp with strcasestr. I agree it would be more useful.

This is better.

> 
> > As for the search UI, I'd rather that it be presented like the symbol search,
> > in a box, instead of just a single line at the top of the screen.
> 
> But then it is not interactive. I was aiming for something similar to
> vim's search, where the search is matched as you type and the only
> free terminal real-estate to display the match string was at the top
> of the screen. I think such a minimal design is better than a
> cumbersome text box which displays the search results afterwards (as
> is symbol search), as the search is only intended for the currently
> displayed menu and the user would usually just want to save the extra
> typing of navigating to a specific menu item.

It was introduced to replace the "hotkey" support, and as such is useful.
If we want to search for content of all prompts then we should extend
the symbols search to do so.
Maybe we should just let it search for both symbols _and_ propmts.

If one search for HOTPLUG_CPU there is no hits in any propmts anyway.
And if one search for "Pentium" there is no config symbol hits.

	Sam
