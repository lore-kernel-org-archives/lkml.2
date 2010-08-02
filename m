Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0HBQdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:33:06 -0400
Received: from xenotime.net ([72.52.115.56]:33419 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751852Ab0HBQdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:33:03 -0400
Date: Mon, 2 Aug 2010 09:32:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: nir.tzachar@gmail.com
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, trapdoor6@gmail.com, justinmattock@gmail.com
Subject: Re: [PATCH] nconfig: add search support
Message-Id: <20100802093257.41a5debe.rdunlap@xenotime.net>
In-Reply-To: <1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
References: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com>
	<1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Aug 2010 10:20:33 +0300 nir.tzachar@gmail.com wrote:

> From: Nir Tzachar <nir.tzachar@gmail.com>
> 
> Remove the old hotkeys feature, and replace by a regular string search.
> From nconfig help:
> 
> Pressing '/' triggers search mode. nconfig does regular string match, case
> insensitive, starting at the begining of each menu line.

What is a "regular string match"?
That's not the same as a regular expression match, right?

Maybe it's a "simple string match"?

> Pressing Enter highlights the next match, Backspace removes one character from
> the match string. Pressing either '/' again or ESC exits search mode.
> 
> Rebind the '/' key (which allowed to search for symbols) to F8
> 
> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
> ---
>  scripts/kconfig/nconf.c |  261 ++++++++++++++++++++++-------------------------
>  scripts/kconfig/nconf.h |    3 +-
>  2 files changed, 125 insertions(+), 139 deletions(-)
> 
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> index 762caf8..2a7cb37 100644
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
> @@ -41,9 +41,12 @@ static const char nconf_readme[] = N_(
>  "   pressing <Enter> of <right-arrow>. Use <Esc> or <left-arrow> to go back.\n"
>  "   Submenus are designated by \"--->\".\n"
>  "\n"
> -"   Shortcut: Press the option's highlighted letter (hotkey).\n"
> -"             Pressing a hotkey more than once will sequence\n"
> -"             through all visible items which use that hotkey.\n"
> +"   Searching: pressing '/' triggers search mode. nconfig does a\n"
> +"              regular string match, case insensitive, starting at\n"
> +"              the begining of each menu line.\n"
> +"              Pressing Enter highlights the next match, Backspace\n"
> +"              removes one character from the match string.\n"
> +"              Pressing either '/' again or ESC exits search mode.\n"
>  "\n"
>  "   You may also use the <PAGE UP> and <PAGE DOWN> keys to scroll\n"
>  "   unseen options into view.\n"


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
