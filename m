Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0EGI4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:56:50 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63975 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab0EGI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XP+YC5uRX+1tLINAiGKnI9f8a23V8qntvqo/MkQGIAzq3qVOJqA7S7puq5caDIpfDU
         aXj/oLqN8Eo89YCRMvsN/xWk2xvvQyZlbob0e/ME8AfL7JL9j5ralnOp/h3GA73l1qBr
         N2o0oA0vYIzw+evF34JahieKILsIGDnWaekas=
MIME-Version: 1.0
In-Reply-To: <4BE3CC6B.2080008@vflare.org>
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org>
	 <1273217107-2023-2-git-send-email-ngupta@vflare.org>
	 <y2m1b68c6791005070103q8cabf3afx22af4a28c6ecf747@mail.gmail.com>
	 <4BE3CC6B.2080008@vflare.org>
Date: Fri, 7 May 2010 17:56:44 +0900
Message-ID: <h2m1b68c6791005070156g9c6be892y852fa52e865a8314@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add flag to identify block swap devices
From: jassi brar <jassisinghbrar@gmail.com>
To: ngupta@vflare.org
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 5:16 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> On 05/07/2010 01:33 PM, jassi brar wrote:
>> On Fri, May 7, 2010 at 4:25 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>>> Added SWP_BLKDEV flag to distinguish block and regular file backed
>>> swap devices. We could also check if a swap is entire block device,
>>> rather than a file, by:
>>> S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)
>>> but, I think, simply checking this flag is more convenient.
>> This might make it convenient for now but is likely to increase complexity and
>> redundancy. Why not define a macro/inline to figure that out?
>>
>
> Accessing such long pointer chain is maybe not good thing to do for
> every swap_entry_free() call? Simple checking a flag is perhaps slightly
> faster? I also can't see how this flag can later increase complexity
> compared to creating new macro for this check.

 I am not sure about effects on the speed, that needs to be seen.
 But here are points against using a new flag....

a) Defining a new flag hogs up precious real-estate of remaining just 2 bits
   (apparently the new flags are to go before SWP_SCANNING)

b) Over time, some dependent code might evolve to depend upon this flag, while
     others might use the indirection to deduct if it is block device
or not. That
    will make it complicated to make any relevant change in future as we'll have
    to keep track of more than one way to check the status. Creating a new
   macro doesn't create a new path to reach the status, but a FLAG does.
