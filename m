Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0LANLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 08:11:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39219 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0LANLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 08:11:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RaTu/0hoTTMqmJ2Fg4YYOYtWDLAiHhJd81JGwXZk9+HnLiuvmWjJ/irO8Gdp2AzMYJ
         TxzN0Hls4CLEbGGjFWq79WhEmUvwrJouZE5TeqAXkQE9EbIxk/bjbn6fcUNYSB5qNVvQ
         iJ9z+hnzF9HRJp1E1u27jdJf+6iC7D2jQ0cPc=
MIME-Version: 1.0
In-Reply-To: <20101130143631.GC26758@redhat.com>
References: <AANLkTimV=6=Je=k6UW=ivJtmR0ONoTrscM2i8YJd5JjA@mail.gmail.com>
	<20101130143631.GC26758@redhat.com>
Date: Wed, 1 Dec 2010 21:11:01 +0800
Message-ID: <AANLkTimAAr7PgH85G+yqOXwdExRUHbZm3HXz0WsRjLuW@mail.gmail.com>
Subject: Re: [PATCH] add rb_next in block throttle
From: Hillf Danton <dhillf@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 10:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Nov 26, 2010 at 10:06:27PM +0800, Hillf Danton wrote:
>> When selecting group for dispatching, the first entry of the service
>> tree is sequentially dequeued, then the first entry is recomputed by
>> calling rb_first().
>>
>> When the first is removed from service tree, new first could also be
>> computed with rb_next(), since it could be faster than rb_first in
>> this special environment.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>
> Ok. So set the leftmost element with the help of rb_next() at the time of
> deletion of existing leftmost element. Not sure whether it is cheaper or
> not but does not harm doing it this way.
>
> Have you tested it to make sure nothing is broken?

Hm..if broken, we rush out and gnarl at Andrea Arcangeli as loud as we could.

Thanks
Hillf
>
> Thanks
> Vivek
>
>>
>> --- a/block/blk-throttle.c    2010-11-01 19:54:12.000000000 +0800
>> +++ b/block/blk-throttle.c    2010-11-26 21:27:40.000000000 +0800
>> @@ -251,7 +251,7 @@ static void rb_erase_init(struct rb_node
>>  static void throtl_rb_erase(struct rb_node *n, struct throtl_rb_root *root)
>>  {
>>       if (root->left == n)
>> -             root->left = NULL;
>> +             root->left = rb_next(n);
>>       rb_erase_init(n, &root->rb);
>>       --root->count;
>>  }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
