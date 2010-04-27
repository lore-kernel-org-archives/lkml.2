Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0D0UhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:37:05 -0400
Received: from xenotime.net ([72.52.64.118]:43961 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755109Ab0D0UhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:37:01 -0400
Date: Tue, 27 Apr 2010 13:36:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Michal Marek <mmarek@suse.cz>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 4/6] gconfig: fix null pointer warning
Message-Id: <20100427133658.64e25ab5.rdunlap@xenotime.net>
In-Reply-To: <4BD696EC.1090100@cn.fujitsu.com>
References: <4BD696C0.8050500@cn.fujitsu.com>
	<4BD696EC.1090100@cn.fujitsu.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 15:49:00 +0800 Li Zefan wrote:

> In gconfig if you enable "Show all options", you'll see some "(null)"
> config options, and clicking those options triggers a warning:
> 
> (gconf:9368): Gtk-CRITICAL **: gtk_text_buffer_insert_with_tags: assertion `text != NULL' failed
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
>  scripts/kconfig/gconf.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
> index 1b18329..d669882 100644
> --- a/scripts/kconfig/gconf.c
> +++ b/scripts/kconfig/gconf.c
> @@ -1343,7 +1343,8 @@ static void update_tree(struct menu *src, GtkTreeIter * dst)
>  #endif
>  
>  		if ((opt_mode == OPT_NORMAL && !menu_is_visible(child1)) ||
> -		    (opt_mode == OPT_PROMPT && !menu_has_prompt(child1))) {
> +		    (opt_mode == OPT_PROMPT && !menu_has_prompt(child1)) ||
> +		    (opt_mode == OPT_ALL    && !menu_get_prompt(child1))) {
>  
>  			/* remove node */
>  			if (gtktree_iter_find_node(dst, menu1) != NULL) {
> @@ -1425,7 +1426,7 @@ static void display_tree(struct menu *menu)
>  
>  		if ((opt_mode == OPT_NORMAL && menu_is_visible(child)) ||
>  		    (opt_mode == OPT_PROMPT && menu_has_prompt(child)) ||
> -		    (opt_mode == OPT_ALL))
> +		    (opt_mode == OPT_ALL    && menu_get_prompt(child)))
>  			place_node(child, fill_row(child));
>  #ifdef DEBUG
>  		printf("%*c%s: ", indent, ' ', menu_get_prompt(child));
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
