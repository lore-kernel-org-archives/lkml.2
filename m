Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1DTJze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:55:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58719 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899Ab1DTJzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:55:33 -0400
X-Sasl-enc: 8IiJOH//NCS7jSzOAnjqHbU9TTWf78jakzADjLOsaQtm 1303293333
Message-ID: <4DAEAD94.6070304@fastmail.fm>
Date: Wed, 20 Apr 2011 10:55:32 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 3/7] Char: nozomi, remove useless tty_sem
References: <1303288998-31718-1-git-send-email-jslaby@suse.cz> <1303288998-31718-3-git-send-email-jslaby@suse.cz>
In-Reply-To: <1303288998-31718-3-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/04/2011 09:43, Jiri Slaby wrote:
> tty_sem used to protect tty open count. This was removed in 33dd474a
> but the lock remained in place.
> 
> So remove it completely as it protects nothing now.
> 
> Also this solves Mac's problem with inatomic operation called from
> atomic context (ppp):
> BUG: scheduling while atomic: firefox-bin/1992/0x10000800
> Modules linked in: ...
> Pid: 1992, comm: firefox-bin Not tainted 2.6.38 #1
> Call Trace:
> ...
>  [] ? mutex_lock+0xe/0x21
>  [] ? ntty_write+0x5d/0x192 [nozomi]
>  [] ? __mod_timer.clone.30+0xbe/0xcc
>  [] ? check_preempt_curr+0x60/0x6d
>  [] ? __nf_ct_refresh_acct+0x75/0xbe
>  [] ? ppp_async_push+0xa9/0x3bd [ppp_async]
>  [] ? ppp_async_send+0x34/0x40 [ppp_async]
>  [] ? ppp_push+0x6c/0x4f9 [ppp_generic]
> ...
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: Mac <kmac@poczta.fm>
> Tested-by: Gerald Pfeifer <gerald@pfeifer.com>
> Cc: Jack Stone <jwjstone@fastmail.fm>
Reviewed-by: Jack Stone <jwjstone@fastmail.fm>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Thanks for sorting this Jiri.

Jack
