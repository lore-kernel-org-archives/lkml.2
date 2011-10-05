Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842Ab1JEPHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:07:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934472Ab1JEPHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:07:36 -0400
Message-ID: <4E8C72B6.9030603@suse.cz>
Date: Wed, 05 Oct 2011 17:07:34 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Sanjeev Premi <premi@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix warnings due to unused return values
References: <1316691396-25447-1-git-send-email-premi@ti.com>
In-Reply-To: <1316691396-25447-1-git-send-email-premi@ti.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.9.2011 13:36, Sanjeev Premi wrote:
> The return value of wattrset() is being ignored in the
> code and newer compilers complain about this e.g.
> 
> HOSTCC  scripts/kconfig/lxdialog/checklist.o
> scripts/kconfig/lxdialog/checklist.c: In function print_item:
> scripts/kconfig/lxdialog/checklist.c:40: warning: value computed is not used
> scripts/kconfig/lxdialog/checklist.c:46: warning: value computed is not used
> 
> Let the compiler know that ignore is intentional.
> 
> Signed-off-by: Sanjeev Premi <premi@ti.com>
> ---
> 
>   The patch was created against the last pull from git.kernel.org
>   The 'pull' from github is taking more than few hours...
> 
>   Based on the time stamps at this url, I believe the patch should
>   apply cleanly:
>    https://github.com/torvalds/linux/tree/master/scripts/kconfig/lxdialog

The latest kconfig tree is at http://repo.or.cz/w/linux-kbuild.git,
branch kconfig. You can pull it by

$ git fetch git://repo.or.cz/linux-kbuild.git kconfig:kconfig

> diff --git a/scripts/kconfig/lxdialog/checklist.c b/scripts/kconfig/lxdialog/checklist.c
> index a2eb80f..8407849 100644
> --- a/scripts/kconfig/lxdialog/checklist.c
> +++ b/scripts/kconfig/lxdialog/checklist.c
> @@ -37,20 +37,20 @@ static void print_item(WINDOW * win, int choice, int selected)
>  	list_item[list_width - item_x] = '\0';
>  
>  	/* Clear 'residue' of last item */
> -	wattrset(win, dlg.menubox.atr);
> +	(void)wattrset(win, dlg.menubox.atr);
>  	wmove(win, choice, 0);
>  	for (i = 0; i < list_width; i++)
>  		waddch(win, ' ');
>  
>  	wmove(win, choice, check_x);
> -	wattrset(win, selected ? dlg.check_selected.atr
> +	(void)wattrset(win, selected ? dlg.check_selected.atr

Uhm, not pretty. What ncurses version are you using? Can you post the
output of make V=1 menuconfig? It seems like wattrset is defined as a
macro instead of a function call. FWIW, it does not print any warnings
here with

$ rpm -qf /usr/include/ncurses
ncurses-devel-5.8-2.6.x86_64
and
gcc version 4.6.1 20110801 [gcc-4_6-branch revision 177033] (SUSE Linux)

on openSUSE Factory.

Michal
