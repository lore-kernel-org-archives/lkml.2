Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab1FGQ56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:57:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42084 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab1FGQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=W6BljX9KDZlgBtb1zXcoRnV18lEnbENnqzxDHQjwQgZVGRzwKaEmEv33GYO/fWcUwU
         nLBY0p7argieZH8D5foaLS4m28uc20uVAfGF4e5yghkKittvzCyKwcP+22M8WDo5qlWO
         c9LDqI7TGpVj4UrBxsJTh2/9d0OFaOPjb4WWQ=
Message-ID: <4DEE588E.1050108@suse.cz>
Date: Tue, 07 Jun 2011 18:57:50 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2 2/2] TTY: ntty, add one more sanity check
References: <BANLkTik5QP7e=+FWSa1kLVpCjZpWEtF1PQ@mail.gmail.com> <1307276177-20957-1-git-send-email-jslaby@suse.cz> <1307276177-20957-2-git-send-email-jslaby@suse.cz> <20110607164423.GA32575@kroah.com>
In-Reply-To: <20110607164423.GA32575@kroah.com>
X-Enigmail-Version: 1.2a2pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 06:44 PM, Greg KH wrote:
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
> 
> So, if we ever hit this, what are we going to do with this crash?
> 
> I really don't want to add more BUG_ON() calls to the kernel if at all
> possible.  Or is it the case that we will crash if this case is true
> soon afterward anyway?

Yeah, it will crash something like 10 lines below. The pointer is
dereferenced there.

thanks,
-- 
js
suse labs
