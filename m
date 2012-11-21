Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2KVSon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:44:43 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48086 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab2KVSoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:44:25 -0500
Message-ID: <50AD60EC.3090302@suse.cz>
Date: Thu, 22 Nov 2012 00:17:00 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH 1/1] tty: vt: Remove redundant null check before kfree.
References: <1353475147-28308-1-git-send-email-sachin.kamat@linaro.org> <20121121144624.GA21766@kroah.com> <50AD5916.3030604@suse.cz> <20121121230057.GA29095@kroah.com>
In-Reply-To: <20121121230057.GA29095@kroah.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 12:00 AM, Greg KH wrote:
> On Wed, Nov 21, 2012 at 11:43:34PM +0100, Jiri Slaby wrote:
>> On 11/21/2012 03:46 PM, Greg KH wrote:
>>> On Wed, Nov 21, 2012 at 10:49:07AM +0530, Sachin Kamat wrote:
>>>> --- a/drivers/tty/vt/consolemap.c
>>>> +++ b/drivers/tty/vt/consolemap.c
>>>> @@ -410,10 +410,8 @@ static void con_release_unimap(struct uni_pagedir *p)
>>>>  		kfree(p->inverse_translations[i]);
>>>>  		p->inverse_translations[i] = NULL;
>>>>  	}
>>>> -	if (p->inverse_trans_unicode) {
>>>> -		kfree(p->inverse_trans_unicode);
>>>> -		p->inverse_trans_unicode = NULL;
>>>> -	}
>>>> +	kfree(p->inverse_trans_unicode);
>>>> +	p->inverse_trans_unicode = NULL;
>>>
>>> kfree with NULL is a no-op, but the line after that just caused a kernel
>>> crash if it was NULL, so I can't accept this type of thing.
>>
>> Greg, I'm not sure -- what do you mean here? The change actually looks
>> fine to me... We do not dereference p->inverse_trans_unicode there.
> 
> If we never dereference it, why is it being set to NULL?

I'm not disputing the assignment. Let it there. But I do not see any
issues with the patch. What problem do you see exactly?


-- 
js
suse labs
