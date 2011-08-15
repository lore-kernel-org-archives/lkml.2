Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1HOMLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 08:11:24 -0400
Received: from verro.fugedabout.it ([78.46.95.7]:37280 "EHLO
	verro.fugedabout.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1HOMLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 08:11:23 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Aug 2011 08:11:23 EDT
Message-ID: <4E490B2C.5000900@fabbione.net>
Date: Mon, 15 Aug 2011 14:03:56 +0200
From: "Fabio M. Di Nitto" <fabbione@fabbione.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@us.ibm.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] kernel/printk: do not turn off bootconsole in printk_late_init
 if keep_bootcon
References: <1312934553-17085-1-git-send-email-nacc@us.ibm.com>
In-Reply-To: <1312934553-17085-1-git-send-email-nacc@us.ibm.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/2011 2:02 AM, Nishanth Aravamudan wrote:
> It seems that commit 7bf693951a8e5f7e600a45b74d91d962a453146e doesn't
> always achieve what it aims, as printk_late_init() runs it
> unconditionally turns off all boot consoles. With this patch, I am able
> to see more messages on the boot console in KVM guests than I can
> without, when keep_bootcon is specified.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Greg KH <gregkh@suse.de>
> ---
>  kernel/printk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 37dff34..293a6cc 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1602,7 +1602,7 @@ static int __init printk_late_init(void)
>  	struct console *con;
>  
>  	for_each_console(con) {
> -		if (con->flags & CON_BOOT) {
> +		if (!keep_bootcon && con->flags & CON_BOOT) {
>  			printk(KERN_INFO "turn off boot console %s%d\n",
>  				con->name, con->index);
>  			unregister_console(con);

Patch looks ok to me, just send it through the right channels for inclusion.

Fabio
