Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab0LYVkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 16:40:15 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43086 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0LYVkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 16:40:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YvtMf8R9TGeVu77KtRBQCbWqW76WJPlExCCtfg6RwzoLUQ9WP/TrDSuLb6M68d4Vnc
         qUYDGipMfVyuqc8oC/UUd3Q0VDvwyGaqf+841xAT2BJqteWijHXbsiQZyoHt/4SxlC0l
         2+/K4ctLjVy0zhUeyXqwpfLAE3V51Ru4vwqWI=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012252223380.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012251914370.10759@swampdragon.chaosbits.net>
	<AANLkTik+yrpY8T69w_RQ84ZbRqwkjvFhvxHLBvU14N3f@mail.gmail.com>
	<alpine.LNX.2.00.1012252223380.10759@swampdragon.chaosbits.net>
Date: Sat, 25 Dec 2010 22:40:11 +0100
Message-ID: <AANLkTincx8rSM+72czJ+tTrG=D=aOJLBb9nd9Jt_RsD2@mail.gmail.com>
Subject: Re: [PATCH] Ceph: Fix a use-after-free bug in ceph_destroy_client().
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Sage Weil <sage@newdream.net>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 10:24 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Sat, 25 Dec 2010, richard -rw- weinberger wrote:
>
>> On Sat, Dec 25, 2010 at 7:17 PM, Jesper Juhl <jj@chaosbits.net> wrote:
>> > Hello,
>> >
>> > In net/ceph/ceph_common.c::ceph_destroy_client() the pointer 'client' is
>> > freed by kfree() and subsequently used in a call to dout() - use after
>> > free bug.
>>
>> Not really. %p reads only the address of "client".
>> kfree() does not alter this address.
>>
>
> Ok, I see your point and you are correct. But still, the patch does not
> change behaviour and it makes it absolutely clear that there's no
> use-after-free bug, so it might still have merit... or?

Your patch does not fix a bug.
I would say it's a style fix.

> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
>



-- 
Thanks,
//richard
