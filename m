Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2LRSmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:42:49 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:45701 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2LRSmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:42:47 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] menuconfig: Add Save/Load buttons
Date: Tue, 18 Dec 2012 19:42:37 +0100
User-Agent: KMail/1.13.5 (Linux/3.6.11-treguer; KDE/4.4.5; x86_64; ; )
Cc: Wang YanQing <udknight@gmail.com>, mmarek@suse.cz,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, bp@alien8.de,
        sakiwit@gmail.com, lacombar@gmail.com, lucas.demarchi@profusion.mobi,
        dave@gnu.org, paul.gortmaker@windriver.com, crquan@gmail.com,
        bpoirier@suse.de
References: <20121218044021.GA7475@udknight>
In-Reply-To: <20121218044021.GA7475@udknight>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212181942.38037.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang, All,

On Tuesday 18 December 2012 Wang YanQing wrote:
> If menuconfig have Save/Load button like alternative
> .config editors, xconfig, nconfig, etc.We will have
> a obvious benefit when use menuconfig just like
> when we use others, we can Save/Load our .config quickly
> and conveniently.
> 
> This patch add the Save/Load button for menuconfig.
> 
> [remove trailing space while at it for below line:
> "*)  Formerly when I used Page Down and Page Up, the cursor would be set"
> ]
> 
> Changes:
> V1-V2:
> 1:use PATH_MAX instead of hard code suggested by Yann E. MORIN
> 2:drop the spurious empty-line removal suggested by Yann E. MORIN

The "Changes" section should have been after the '---' mark, below, to
avoid it being in the commit log.

> Signed-off-by: Wang YanQing <udknight@gmail.com>

Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

It works very well, and really mimicks the behavior we have in nconf! :-)

(But see a very minor comment below.)

> ---
>  scripts/kconfig/lxdialog/menubox.c | 20 +++++++++++---------
>  scripts/kconfig/mconf.c            | 30 +++++++++++++++++++++++++-----
>  2 files changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/scripts/kconfig/lxdialog/menubox.c b/scripts/kconfig/lxdialog/menubox.c
> index 1d60473..8b534d5 100644
> --- a/scripts/kconfig/lxdialog/menubox.c
> +++ b/scripts/kconfig/lxdialog/menubox.c
[--SNIP--]
> @@ -154,12 +154,14 @@ static void print_arrows(WINDOW * win, int item_no, int scroll, int y, int x,
>   */
>  static void print_buttons(WINDOW * win, int height, int width, int selected)
>  {
> -	int x = width / 2 - 16;
> +	int x = width / 2 - 26;

That's not well centered (sorry, I initially missed it), this should
have been '28':
( nb_buttons * button_size + (nb_buttons - 1) * button_separation ) / 2
(      5     *      8      + (     5     - 1) *        4          ) / 2 = 28

But that's just eye-candy, and only is only obvious on very small terminals.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
