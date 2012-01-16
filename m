Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2APIF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:05:56 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:64910 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977Ab2APIFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:05:54 -0500
Date: Mon, 16 Jan 2012 16:05:16 +0800
From: Wang YanQing <udknight@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Michal Marek <mmarek@suse.cz>, Cong Wang <amwang@redhat.com>,
        Arnaud Lacombe <lacombar@gmail.com>, Davidlohr Bueso <dave@gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] menuconfig: fix a regression when canceling the prompt
 dialog at exit
Message-ID: <20120116080516.GA7447@udknight>
Mail-Followup-To: Wang YanQing <Udknight@gmail.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Michal Marek <mmarek@suse.cz>,
	Cong Wang <amwang@redhat.com>, Arnaud Lacombe <lacombar@gmail.com>,
	Davidlohr Bueso <dave@gnu.org>, LKML <linux-kernel@vger.kernel.org>,
	linux-kbuild@vger.kernel.org
References: <4F13CB49.8030004@cn.fujitsu.com>
 <1326698421.4151.4.camel@cr0>
 <4F13D216.3060705@cn.fujitsu.com>
 <4F13D873.4070808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F13D873.4070808@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 03:57:39PM +0800, Li Zefan wrote:
> This commit fixes a bug, while introducing a new one..
> 
> commit 7203ddbd4be9720649e47d756a001e0c7d7f8ae2
> Author: Wang YanQing <udknight@gmail.com>
> Date:   Thu Jan 12 11:31:32 2012 +0800
> 
>     menuconfig: let make not report error when not save configuration
> 
> Pressing ESC should cancel the yes/no dialog and return back to
> the main menu, but not exit from menuconfig.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Wang YanQing <udknight@gmail.com>

> ---
>  scripts/kconfig/mconf.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
> index 86cd1ea..2c6286c 100644
> --- a/scripts/kconfig/mconf.c
> +++ b/scripts/kconfig/mconf.c
> @@ -830,7 +830,8 @@ static int handle_exit(void)
>  		fprintf(stderr, _("\n\n"
>  				  "Your configuration changes were NOT saved."
>  				  "\n\n"));
> -		res = 0;
> +		if (res != KEY_ESC)
> +			res = 0;
>  	}
>  
>  	return res;
> -- 
> 1.7.3.1
