Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0HCKA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:00:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0HCKA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:00:58 -0400
Message-ID: <4C57E88B.8070505@suse.cz>
Date: Tue, 03 Aug 2010 11:59:39 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kbuild@vger.kernel.org, zippel@linux-m68k.org,
        lkml <linux-kernel@vger.kernel.org>,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: [PATCH]scripts/kconfig/nconf.gui.c Fix warning: value computed
 is not used
References: <1280790966-417-1-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1280790966-417-1-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.8.2010 01:16, Justin P. Mattock wrote:
> The below patch fixes some warning messages Im getting when doing
> make nconfig
> 
>  make nconfig
>   HOSTCC  scripts/kconfig/nconf.gui.o
> scripts/kconfig/nconf.gui.c: In function 'print_in_middle':
> scripts/kconfig/nconf.gui.c:170:2: warning: value computed is not used
> scripts/kconfig/nconf.gui.c: In function 'btn_dialog':
> scripts/kconfig/nconf.gui.c:300:2: warning: value computed is not used
> scripts/kconfig/nconf.gui.c:304:2: warning: value computed is not used
> scripts/kconfig/nconf.gui.c: In function 'dialog_inputbox':
> scripts/kconfig/nconf.gui.c:395:2: warning: value computed is not used
> scripts/kconfig/nconf.gui.c:397:2: warning: value computed is not used
> scripts/kconfig/nconf.gui.c:399:2: warning: value computed is not used
> scripts/kconfig/nconf.gui.c:404:2: warning: value computed is not used
> scripts/kconfig/nconf.gui.c: In function 'show_scroll_win':
> scripts/kconfig/nconf.gui.c:534:2: warning: value computed is not used
> scripts/kconfig/nconf.gui.c:549:2: warning: value computed is not used
> scripts/kconfig/nconf.gui.c:551:2: warning: value computed is not used
>   HOSTLD  scripts/kconfig/nconf
> scripts/kconfig/nconf arch/x86/Kconfig
> 
> I looked around for a way to fix these, but am not familiar with ncurses.
> if there's a better way let me know and/or send a seperate fix.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  scripts/kconfig/nconf.gui.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
> index a9d9344..08a5a04 100644
> --- a/scripts/kconfig/nconf.gui.c
> +++ b/scripts/kconfig/nconf.gui.c
> @@ -167,7 +167,6 @@ void print_in_middle(WINDOW *win,
>  	length = strlen(string);
>  	temp = (width - length) / 2;
>  	x = startx + (int)temp;
> -	wattrset(win, color);

Huh? :) This change makes nconfig look black and white. I'm all for
eliminating warnings, but please do not eliminate features at the same
time (or submit a patch with "Subject: make nconfig black and white" and
do not mask it as warning fixes).

Michal
