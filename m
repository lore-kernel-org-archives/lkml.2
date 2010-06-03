Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab0FCQer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:34:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34505 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0FCQep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:34:45 -0400
Message-ID: <4C07D932.4040404@oracle.com>
Date: Thu, 03 Jun 2010 09:32:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Michal Marek <mmarek@suse.cz>, Nobin Mathew <nobin.mathew@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] menuconfig: truncate list items
References: <4C0758B7.5070907@cn.fujitsu.com> <4C0758C9.7080108@cn.fujitsu.com>
In-Reply-To: <4C0758C9.7080108@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C07D98A.00D9:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/10 00:24, Li Zefan wrote:
> Truncate list items to fit in a single line, otherwise those items
> which have long prompts will cover some other items.
> 
> This follows the behavior of menubox.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks :)

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Ben, the Samsung S3C24* prompt still gets truncated with this patch (when using
an 80-column wide xterm).  If you care about seeing all of the models,
you might want to shorten the prompt.


> ---
>  scripts/kconfig/lxdialog/checklist.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/kconfig/lxdialog/checklist.c b/scripts/kconfig/lxdialog/checklist.c
> index c92a05a..a2eb80f 100644
> --- a/scripts/kconfig/lxdialog/checklist.c
> +++ b/scripts/kconfig/lxdialog/checklist.c
> @@ -31,6 +31,10 @@ static int list_width, check_x, item_x;
>  static void print_item(WINDOW * win, int choice, int selected)
>  {
>  	int i;
> +	char *list_item = malloc(list_width + 1);
> +
> +	strncpy(list_item, item_str(), list_width - item_x);
> +	list_item[list_width - item_x] = '\0';
>  
>  	/* Clear 'residue' of last item */
>  	wattrset(win, dlg.menubox.atr);
> @@ -45,13 +49,14 @@ static void print_item(WINDOW * win, int choice, int selected)
>  		wprintw(win, "(%c)", item_is_tag('X') ? 'X' : ' ');
>  
>  	wattrset(win, selected ? dlg.tag_selected.atr : dlg.tag.atr);
> -	mvwaddch(win, choice, item_x, item_str()[0]);
> +	mvwaddch(win, choice, item_x, list_item[0]);
>  	wattrset(win, selected ? dlg.item_selected.atr : dlg.item.atr);
> -	waddstr(win, (char *)item_str() + 1);
> +	waddstr(win, list_item + 1);
>  	if (selected) {
>  		wmove(win, choice, check_x + 1);
>  		wrefresh(win);
>  	}
> +	free(list_item);
>  }
>  
>  /*


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
