Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482Ab2HJC3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:29:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53571 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2HJC3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120809070154.GG2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-13-git-send-email-koverstreet@google.com>
	<Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
	<20120808232804.GL6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<CAFR8uedZiG0NWgWQQa03r+kKh8rT0jzpj+hwPzq+i7K6zhpT_A@mail.gmail.com>
	<20120809070154.GG2845@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Thu, 9 Aug 2012 19:29:04 -0700
Message-ID: <CAFR8uedwrfv8TB==BkDTZAENYhDOY8S++aTqEoJ7xbn7Vo-6Ag@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH v5 12/12] block: Only clone bio vecs that are
 in use
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>,
        vgoyal@redhat.com, yehuda@hq.newdream.net, sage@newdream.net,
        agk@redhat.com, drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Thu, Aug 9, 2012 at 12:01 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, Aug 08, 2012 at 04:47:46PM -0700, Muthu Kumar wrote:
>> You are changing the meaning of __bio_clone() here. In old code, the
>> number of io_vecs, bi_idx, bi_vcnt are preserved. But in this modified
>> code, you are mapping bio_src's bi_iovec[bi_idx] to bio_dests
>> bi_iovec[0] and also restricting the number of allocated io_vecs of
>> the clone. It may be useful for cases were we would like a identical
>> copy of the original bio (may not be in current code base, but this
>> implementation is definitely not what one would expect from the name
>> "clone").
>
> Implementation details changed somewhat but the high-level semantics
> didn't change at all.  Any driver not messing with bio internals - and
> they shouldn't - shouldn't notice the change.

The reason for doing this change is because the code in question is
messing with bio internals.

No in-kernel drivers
> seem to be broken by the change.  If you ask me, this looks more like
> a bug fix to me where the bug is a silly behavior restricting
> usefulness of the interface.
>
>> May be, call this new implementation some thing else (and use it for bcache)?
>
> This doesn't only change __bio_clone() but all clone interface stacked
> on top of it, so, no way.

>This ain't windows.

ah... when you put it this way, it gets a different perspective :)

Anyway, my point is, we shouldn't make it non-obvious ("clone" should
be just "clone"). But, we can always add more comments i guess.

Regards,
Muthu


>
> Thanks.
>
> --
> tejun
