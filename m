Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642Ab2EJVsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:48:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43472 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab2EJVsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <1336675787.22495.29.camel@joe2Laptop>
References: <cover.1336619038.git.koverstreet@google.com>
	<1188908028.170.1336674698865.JavaMail.mail@webmail09>
	<1336675787.22495.29.camel@joe2Laptop>
Date: Thu, 10 May 2012 14:48:49 -0700
Message-ID: <CAH+dOxLfFScjKP8XEyQjAKwqGz4zGzASi15wEoXOgvXCqaSsCQ@mail.gmail.com>
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
From: Kent Overstreet <koverstreet@google.com>
To: Joe Perches <joe@perches.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't feel strongly one way or the other about it, but I do think
it's more just a matter of taste - the if (0) is ugly, I'll certainly
grant you that but IMO it makes the weird control flow harder to miss,
and the indentation more or less matches the control flow.

But I haven't come up with a way of writing that I actually like, I
dislike them all almost equally.

On Thu, May 10, 2012 at 11:49 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-05-09 at 23:10 -0400, Kent Overstreet wrote:
>> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> []
>> +
>> +void btree_read_done(struct closure *cl)
>> +{
> []
>> +     if (b->written < btree_blocks(b))
>> +             bset_init_next(b);
>> +
>> +     if (0) {
>> +err:         set_btree_node_io_error(b);
>> +             cache_set_error(b->c, "%s at bucket %lu, block %zu, %u keys",
>> +                             err, PTR_BUCKET_NR(b->c, &b->key, 0),
>> +                             index(i, b), i->keys);
>> +     }
>
> Hi Kent
>
> trivia:  This if (0) is an exceedingly ugly style.
>
> I'd much prefer:
>
>        if (foo)
>                bar();
>
>        goto exit;
>
> err:
>        set_btree_node_io_error(b);
>        cache_set_error(b->c, "%s at bucket %lu, block %zu, %u keys",
>                        err, PTR_BUCKET_NR(b->c, &b->key, 0),
>                        index(i, b), i->keys);
>
> exit:
>        etc...
>
>
