Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab0HHS6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 14:58:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42476 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0HHS6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 14:58:32 -0400
Date: Sun, 8 Aug 2010 20:58:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: nir.tzachar@gmail.com
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: resend [PATCH] nconfig: properly map function keys.
Message-ID: <20100808185831.GA6213@merkur.ravnborg.org>
References: <20100808154233.GB4205@merkur.ravnborg.org> <1281287460-32332-1-git-send-email-nir.tzachar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281287460-32332-1-git-send-email-nir.tzachar@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 08, 2010 at 08:11:00PM +0300, nir.tzachar@gmail.com wrote:
> From: Nir Tzachar <nir.tzachar@gmail.com>
> 
> Previous patch was missing a '~' in F7.
> 
> When $TERM=xterm,xterm-color,vt220 map function keys properly.
> 
> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>
> ---
>  scripts/kconfig/nconf.c |   23 ++++++++++++++++++++---
>  1 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
> index c6feb41..a641a66 100644
> --- a/scripts/kconfig/nconf.c
> +++ b/scripts/kconfig/nconf.c
> @@ -1537,13 +1537,13 @@ int main(int ac, char **av)
>  
>  	/* Initialize curses */
>  	initscr();
> -	/* set color theme */
> -	set_colors();
> -
>  	cbreak();
>  	noecho();
>  	keypad(stdscr, TRUE);
>  	curs_set(0);
> +	/* set color theme */
> +	set_colors();
> +
>  
>  	if (COLS < 75 || LINES < 20) {
>  		endwin();
> @@ -1552,6 +1552,23 @@ int main(int ac, char **av)
>  		return 1;
>  	}
>  
> +	const char *term = getenv("TERM");
> +	if (strcmp(term, "xterm") == 0 ||
> +	    strcmp(term, "xterm-color") == 0 ||
> +	    strcmp(term, "vt220") == 0) {
> +		define_key("\033[H", KEY_HOME);
> +		define_key("\033[F", KEY_END);
> +		define_key("\033OP", KEY_F(1));
> +		define_key("\033OQ", KEY_F(2));
> +		define_key("\033OR", KEY_F(3));
> +		define_key("\033OS", KEY_F(4));

I had to change the above to "\033[11~", "\033[12~" etc, then it worked.
My terminal emulation is xterm and I did not try any other.

	Sam

