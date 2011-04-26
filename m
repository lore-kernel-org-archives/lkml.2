Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1DZKHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:07:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47201 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1DZKHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tq8nmTWTthkCPTqCMwQAYkTX4j7Fs4waW7GWhsPOAY78RrX86Y7X751ZJVB2JNqnxa
         Lp67F1h5aFKFxwAk6jFvL5mX4pOmFxB9gAz8RONL1Xjf0flI0ip4Qg8xvlXV2Flt/78t
         eSHZ3gyPImQAtEPMkvU/Lfh/9FgBnNoupuXLc=
Message-ID: <4DB6994B.3060204@suse.cz>
Date: Tue, 26 Apr 2011 12:07:07 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0a2) Gecko/20110420 Thunderbird/3.3a4pre
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 090/173] USB: serial/kobil_sct, fix potential tty NULL
 dereference
References: <20110425200236.905912775@pcw.home.local>
In-Reply-To: <20110425200236.905912775@pcw.home.local>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2011 10:04 PM, Willy Tarreau wrote:
> 2.6.27.59-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Jiri Slaby<jslaby@suse.cz>
>
> commit 6960f40a954619857e7095a6179eef896f297077 upstream.
>
> Make sure that we check the return value of tty_port_tty_get.
> Sometimes it may return NULL and we later dereference that.
>
> The only place here is in kobil_read_int_callback, so fix it.
>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Cc: Alan Cox<alan@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>
> ---
>   drivers/usb/serial/kobil_sct.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/usb/serial/kobil_sct.c
> +++ b/drivers/usb/serial/kobil_sct.c
> @@ -372,7 +372,7 @@ static void kobil_read_int_callback(stru
>   	}
>
>   	tty = port->port.tty;
> -	if (urb->actual_length) {
> +	if (tty&&  urb->actual_length) {

Ok, but this doesn't fix the bug (the URB should be killed or something 
similar in that kernel), it only makes the window smaller.

regards,
-- 
js
suse labs
