Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2GaNSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:18:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab2GaNSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:18:01 -0400
Date: Tue, 31 Jul 2012 09:17:51 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Borislav Petkov <borislav.petkov@amd.com>, Michal Marek <mmarek@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/6] menuconfig: jump to search results
Message-ID: <20120731131751.GA10910@d2.synalogic.ca>
References: <1343676130-29770-1-git-send-email-bpoirier@suse.de>
 <20120730195826.GA8242@liondog.tnic>
 <20120730202212.GA31790@d2.synalogic.ca>
 <20120731075751.GB23595@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120731075751.GB23595@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/07/31 09:57, Borislav Petkov wrote:
> On Mon, Jul 30, 2012 at 04:22:12PM -0400, Benjamin Poirier wrote:
> > It's against linux-next, which already contains some patches for
> > menuconfig.
> 
> Ok, applying against the linux-next from today succeeds. And they seem
> to work, I can search for CONFIG_* stuff and then go straight to the
> results.
> 
> A couple more observations:
> 
> * The numbering in the search results looks kinda strange and
> non-intuitive IMHO. Would it be possible to use the ncurses cursor to
> iterate over the search results like one does in the normal menus? I.e.,
> the horizontal bar which highlights the item with the background color
> or whatever - can it be moved up and down with the arrow keys through
> the search results too?

Further patches are welcome ;) It's not a trivial difference though.
The "horizontal bar" is not a curses concept, it's implemented via the
menubox lxdialog whereas search results are currently presented via a
textbox lxdialog.

> 
> * when searching for "DELAY" for example, I get results without numbers
> to which I can't jump to:
> 
> ...
>   │ Symbol: DEFAULT_IO_DELAY_TYPE [=0]
>   │ Type  : integer
>   │
>   │
>   │ Symbol: IO_DELAY_TYPE_0X80 [=0]
>   │ Type  : integer
> ...
> 
> maybe because they don't have "---help---" section?

Because they don't have a prompt - they don't appear in any menu at all.
In that case there's nowhere to jump to. That's why those symbols don't
get a number.

> 
> In those cases, you probably want to hide those from the search results?
> 
> Other than that it looks good and I'd say we need more menuconfig
> functionality like that which eases/speeds up working with that thing :).
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
