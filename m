Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1AYXFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 18:05:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58227 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab1AYXFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 18:05:39 -0500
MIME-Version: 1.0
In-Reply-To: <201101252354.31217.PeterHuewe@gmx.de>
References: <1295988851-23561-1-git-send-email-peterhuewe@gmx.de>
	<Pine.LNX.4.64.1101252319570.3668@ask.diku.dk>
	<201101252354.31217.PeterHuewe@gmx.de>
Date: Tue, 25 Jan 2011 18:05:37 -0500
Message-ID: <AANLkTinap-4djdUORmOnnnVFtTm4wSxMqTNVxrfg2jYw@mail.gmail.com>
Subject: Re: [PATCH] video/saa7164: Fix sparse warning: Using plain integer as
 NULL pointer
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: Julia Lawall <julia@diku.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Steven Toth <stoth@kernellabs.com>,
        Tejun Heo <tj@kernel.org>, Dan Carpenter <error27@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 5:54 PM, Peter Hüwe <PeterHuewe@gmx.de> wrote:
> Hi Julia,
>
> thanks for your input.
> So do I understand you correctly if I say
> if(!x) is better than if(x==NULL) in any case?
>
> Or only for the kmalloc family?
>
> Do you remember the reason why !x should be preferred?
>
> In Documentation/CodingStyle ,  Chapter 7: Centralized exiting of functions
> there is a function fun with looks like this:
> int fun(int a)
> {
>    int result = 0;
>    char *buffer = kmalloc(SIZE);
>
>    if (buffer == NULL)
>        return -ENOMEM;
>
>    if (condition1) {
>        while (loop1) {
>            ...
>        }
>        result = 1;
>        goto out;
>    }
>    ...
> out:
>    kfree(buffer);
>    return result;
> }
>
>
> -->  So   if (buffer == NULL) is in the official CodingStyle - maybe we should
> add a paragraph there as well ;)
>
>
> Don't get me wrong, I just want to learn ;)

To my knowledge, the current CodingStyle doesn't enforce a particular
standard in this regard, leaving it at the discretion of the author.

Whether to do (!foo) or (foo == NULL) is one of those debates people
have similar to whether to use tabs as whitespace.  People have
differing opinions and there is no clearly "right" answer.  Personally
I strongly prefer (foo == NULL) as it makes it blindingly obvious that
it's a pointer comparison, whereas (!foo) leaves you wondering whether
it's an integer or pointer comparison.

All that said, you shouldn't submit patches which arbitrarily change
from one format to the other.  With regards to the proposed patch, you
should follow whatever style the author employed in the rest of the
file.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
