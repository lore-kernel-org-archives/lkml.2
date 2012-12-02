Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2LBRw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 12:52:57 -0500
Received: from mail-wg0-f66.google.com ([74.125.82.66]:64197 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2LBRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 12:52:55 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4]menuconfig: Add Save button
Date: Sun, 2 Dec 2012 18:52:50 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.8-treguer; KDE/4.4.5; x86_64; ; )
Cc: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, bp@alien8.de,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
References: <20121201161316.GA15246@udknight>
In-Reply-To: <20121201161316.GA15246@udknight>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212021852.51113.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang, All,

On Saturday 01 December 2012 Wang YanQing wrote:
> If menuconfig have a Save button like alternative
> .config editors, xconfig, nconfig, etc.We will have
> a obvious benefit when use menuconfig just like
> when we use others, we can save our .config quickly
> and conveniently.
> 
> This patch add the Save button for menuconfig.

To make the behavior consistent, may I suggest that you push the
concept even a bit further:
  - add a "Load" *and* a "Save" buttons
  - get rid of the top-level "Load an Alternate Configuration File"
    and "Save an Alternate Configuration File" entries

For the "Save" and "Load" buttons, please mimick how the nconf frontend
behaves: prompt for the file to save to/load from, and prefill it with
the last filename that was entered (".config" per default).

Of course, two patches for that: one for the "Save/Load" buttons, one
to get rid of the top-level entries afterward.

Note: I do not state that your use-case is valid or not. That's your
call how you configure and test your kernel. However, I think that
having a consistent behavior across the frontends is a very nice goal
to pursue.

See other comments in-lined, below.

> V1-V2: Rewrite the most code to make it more correct
> V2-V3: Fix the behavior of conf_message_callback when exit.
> V3-V4:
> 1: Move Buttons a little left to make them look like symmetrical.
> 2: Exchange the position between Save button and Exit button.
> 3: Use conf_save instead of conf_write to make we can save
> an alternate configuration file with Save button.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  scripts/kconfig/lxdialog/menubox.c | 21 +++++++++---------
>  scripts/kconfig/mconf.c            | 45 ++++++++++++++++++++++++++++++--------
>  2 files changed, 47 insertions(+), 19 deletions(-)
> 
> diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
> index 1d60473..b445bda 100644
> --- a/scripts/kconfig/lxdialog/menubox.c
> +++ b/scripts/kconfig/lxdialog/menubox.c
> @@ -26,7 +26,7 @@
>   *
>   *    *)  A bugfix for the Page-Down problem
>   *
> - *    *)  Formerly when I used Page Down and Page Up, the cursor would be set 
> + *    *)  Formerly when I used Page Down and Page Up, the cursor would be set

Space-damage. Don't send trailing-space fixes, or at least add a quick
note for it at the end of the commit log (eg.: "remove trailing space
while at it").

>   *        to the first position in the menu box.  Now lxdialog is a bit
>   *        smarter and works more like other menu systems (just have a look at
>   *        it).
> @@ -154,12 +154,13 @@ static void print_arrows(WINDOW * win, int item_no, int scroll, int y, int x,
>   */
>  static void print_buttons(WINDOW * win, int height, int width, int selected)
>  {
> -	int x = width / 2 - 16;
> +	int x = width / 2 - 20;
>  	int y = height - 2;
>  
>  	print_button(win, gettext("Select"), y, x, selected == 0);
> -	print_button(win, gettext(" Exit "), y, x + 12, selected == 1);
> +	print_button(win, gettext(" Save "), y, x + 12, selected == 1);
>  	print_button(win, gettext(" Help "), y, x + 24, selected == 2);
> +	print_button(win, gettext(" Exit "), y, x + 36, selected == 3);

The re-ordering should be in a separate patch.
It makes it difficult to separate the code for the new feature from
the churn due to the re-ordering.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
