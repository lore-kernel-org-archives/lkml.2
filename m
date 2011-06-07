Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1FGRal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:30:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38129 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab1FGRaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:30:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nwnMCMn96cmHEZT0cjOr6tXKdoLxpHrXe3qZfGKUMU39HMANDKnkSU/skK+fhfJwYx
         0hJV16XT6P1ykjHdCC8kWsAASDvxlL1NPoJ42jfdwucckESRrukRCe9heQ7bsmSLW+id
         HFKjQT4eYTIeTMA0MpRwqATUFZBsK6UkLgqKs=
Message-ID: <4DEE6037.1020400@suse.cz>
Date: Tue, 07 Jun 2011 19:30:31 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: TTY: ntty, add one more sanity check
References: <BANLkTik5QP7e=+FWSa1kLVpCjZpWEtF1PQ@mail.gmail.com> <1307276177-20957-1-git-send-email-jslaby@suse.cz> <1307276177-20957-2-git-send-email-jslaby@suse.cz> <20110607172014.GA13661@kroah.com>
In-Reply-To: <20110607172014.GA13661@kroah.com>
X-Enigmail-Version: 1.2a2pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 07:20 PM, Greg KH wrote:
> On Sun, Jun 05, 2011 at 02:16:17PM +0200, Jiri Slaby wrote:
>> With the previous patch, we fixed another bug where read_buf was freed
>> while we still was in n_tty_read. We currently check whether read_buf
>> is NULL at the start of the function. Add one more check after we wake
>> up from waiting for input.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> ---
>>  drivers/tty/n_tty.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
>> index 95d0a9c..c62c856 100644
>> --- a/drivers/tty/n_tty.c
>> +++ b/drivers/tty/n_tty.c
>> @@ -1785,6 +1785,7 @@ do_it_again:
>>  				break;
>>  			}
>>  			timeout = schedule_timeout(timeout);
>> +			BUG_ON(!tty->read_buf);
>>  			continue;
>>  		}
>>  		__set_current_state(TASK_RUNNING);
> 
> This doesn't apply anymore without some fuzz as stuff has changed in
> this area in Linus's tree.
> 
> Can you refresh it and resend it so that I know it's correct?
> 
> Or, just verify that the diff below is correct, and I'll take that one.

Yes, it's correct.

> thanks,
> 
> greg k-h
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 0ad3288..c3954fb 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -1815,6 +1815,7 @@ do_it_again:
>  			/* FIXME: does n_tty_set_room need locking ? */
>  			n_tty_set_room(tty);
>  			timeout = schedule_timeout(timeout);
> +			BUG_ON(!tty->read_buf);
>  			continue;
>  		}
>  		__set_current_state(TASK_RUNNING);

thanks,
-- 
js
suse labs
