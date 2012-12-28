Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2L1S6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 13:58:54 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:50036 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2L1S6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 13:58:52 -0500
Date: Fri, 28 Dec 2012 22:51:08 +0400
From: Dmitry Voytik <dvv.kernel@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, dvv.kernel@gmail.com
Subject: Re: [PATCH] nconf: add j, k and l keys for menu navigation
Message-ID: <20121228185108.GA13644@voyt-hp>
References: <1356117145-14158-1-git-send-email-dvv.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356117145-14158-1-git-send-email-dvv.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Please don't apply this patch. I am going to send the new version.
Thank you.

On Fri, Dec 21, 2012 at 11:12:25PM +0400, Dmitry Voytik wrote:
> Add vi-style keys for menu navigation: press j/k for down/up navigation
> and l for entering to a submenu. Unfortantely h key is reserved for
> the items help.
> 
> Signed-off-by: Dmitry Voytik <dvv.kernel@gmail.com>
> ---
>  scripts/kconfig/nconf.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> index ce93e87..ccf6766 100644
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
> @@ -38,10 +38,10 @@ static const char nconf_readme[] = N_(
>  "\n"
>  "Menus\n"
>  "----------\n"
> -"o  Use the Up/Down arrow keys (cursor keys) to highlight the item\n"
> -"   you wish to change use <Enter> or <Space>. Goto submenu by \n"
> -"   pressing <Enter> of <right-arrow>. Use <Esc> or <left-arrow> to go back.\n"
> -"   Submenus are designated by \"--->\".\n"
> +"o  Use the Up/Down arrow keys (cursor keys) or <j>/<k> to highlight\n"
> +"   the item you wish to change use <Enter> or <Space>. Goto submenu by\n"
> +"   pressing <Enter>, <right-arrow> or <l>. Use <Esc> or <left-arrow>\n"
> +"   to go back. Submenus are designated by \"--->\".\n"
>  "\n"
>  "   Searching: pressing '/' triggers interactive search mode.\n"
>  "              nconfig performs a case insensitive search for the string\n"
> @@ -1115,9 +1115,11 @@ static void conf(struct menu *menu)
>  						(struct menu *) item_data()))
>  				break;
>  			switch (res) {
> +			case 'j':
>  			case KEY_DOWN:
>  				menu_driver(curses_menu, REQ_DOWN_ITEM);
>  				break;
> +			case 'k':
>  			case KEY_UP:
>  				menu_driver(curses_menu, REQ_UP_ITEM);
>  				break;
> @@ -1141,7 +1143,7 @@ static void conf(struct menu *menu)
>  			if (res == 10 || res == 27 ||
>  				res == 32 || res == 'n' || res == 'y' ||
>  				res == KEY_LEFT || res == KEY_RIGHT ||
> -				res == 'm')
> +				res == 'm' || res == 'l')
>  				break;
>  			refresh_all_windows(main_window);
>  		}
> @@ -1170,6 +1172,7 @@ static void conf(struct menu *menu)
>  			else if (item_is_tag('m'))
>  				conf(submenu);
>  			break;
> +		case 'l':
>  		case KEY_RIGHT:
>  		case 10: /* ENTER WAS PRESSED */
>  			switch (item_tag()) {
> -- 
> 1.7.9.5
> 
