Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2FDUsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:48:02 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57757 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab2FDUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:48:00 -0400
Message-ID: <4FCD1EF9.6000001@suse.cz>
Date: Mon, 04 Jun 2012 22:47:53 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120530 Thunderbird/14.0a2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: user-mode-linux-devel@lists.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        alan@linux.intel.com
Subject: Re: [PATCH 5/6] um: fully use tty_port
References: <1338841657-30358-1-git-send-email-richard@nod.at> <1338841657-30358-6-git-send-email-richard@nod.at>
In-Reply-To: <1338841657-30358-6-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 10:27 PM, Richard Weinberger wrote:
> +void line_cleanup(struct tty_struct *tty)
> +{
> +	struct line *line = tty->driver_data;
>  
>  	if (line->sigio) {
>  		unregister_winch(tty);
>  		line->sigio = 0;

r u sure you want to to do this asynchronously? This should be
tty_port_operations->shutdown I suppose...

>  	}
> +}

Anyway, please split the patch into 2 pieces at least:
1) introducing ->install and moving the setup there.
2) switching to tty port helpers
Otherwise it's a hard-to-review mess.

thanks,
-- 
js
suse labs


