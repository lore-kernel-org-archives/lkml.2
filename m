Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1IUUQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:16:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34675 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1IUUQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:16:15 -0400
MIME-Version: 1.0
In-Reply-To: <1313818133-25087-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <CACqU3MWoa5eNpgODqAKDSBZOL61OFWVqaKe_cH=bOMbxjRM0rA@mail.gmail.com>
 <1313818133-25087-1-git-send-email-lucas.demarchi@profusion.mobi>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Wed, 21 Sep 2011 17:15:55 -0300
Message-ID: <CAMOw1v4mJe-akdgkJ_y755v=kQ1Dj=COeKaOc3qT1EGP=raKYw@mail.gmail.com>
Subject: Re: [PATCH] kconfig: fix set but not used variables
To: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal

On Sat, Aug 20, 2011 at 2:28 AM, Lucas De Marchi
<lucas.demarchi@profusion.mobi> wrote:
> Some variables were being set but never used, which was triggering
> warnings in GCC >= 4.6.
>
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

Did you apply this patch?


regards,
Lucas De Marchi
