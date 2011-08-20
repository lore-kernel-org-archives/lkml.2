Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab1HTA2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 20:28:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38367 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1HTA2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 20:28:33 -0400
MIME-Version: 1.0
In-Reply-To: <1313419269-3860-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1313419269-3860-1-git-send-email-lucas.demarchi@profusion.mobi>
Date: Fri, 19 Aug 2011 20:28:33 -0400
Message-ID: <CACqU3MWoa5eNpgODqAKDSBZOL61OFWVqaKe_cH=bOMbxjRM0rA@mail.gmail.com>
Subject: Re: [PATCH] kconfig: fix set but not used variables
From: Arnaud Lacombe <lacombar@gmail.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 15, 2011 at 10:41 AM, Lucas De Marchi
<lucas.demarchi@profusion.mobi> wrote:
> Some variables were being set but never used, which was triggering
> warnings in recent versions of GCC.
>
Please be specific about the version of gcc triggering the warning. In
5 years, "recent version" will mean something than today.

Thanks,
 - Arnaud

> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> ---
>  scripts/kconfig/lxdialog/textbox.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/kconfig/lxdialog/textbox.c b/scripts/kconfig/lxdialog/textbox.c
> index c704712..154c2dd 100644
> --- a/scripts/kconfig/lxdialog/textbox.c
> +++ b/scripts/kconfig/lxdialog/textbox.c
> @@ -320,7 +320,6 @@ static void print_page(WINDOW * win, int height, int width)
>  */
>  static void print_line(WINDOW * win, int row, int width)
>  {
> -       int y, x;
>        char *line;
>
>        line = get_line();
> @@ -329,10 +328,10 @@ static void print_line(WINDOW * win, int row, int width)
>        waddch(win, ' ');
>        waddnstr(win, line, MIN(strlen(line), width - 2));
>
> -       getyx(win, y, x);
>        /* Clear 'residue' of previous line */
>  #if OLD_NCURSES
>        {
> +               int x = getcurx(win);
>                int i;
>                for (i = 0; i < width - x; i++)
>                        waddch(win, ' ');
> --
> 1.7.6
>
>
