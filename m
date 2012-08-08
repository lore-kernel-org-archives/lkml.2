Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab2HHXrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:47:48 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64806 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab2HHXrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:47:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120808232804.GL6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-13-git-send-email-koverstreet@google.com>
	<Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
	<20120808232804.GL6983@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Wed, 8 Aug 2012 16:47:46 -0700
Message-ID: <CAFR8uedZiG0NWgWQQa03r+kKh8rT0jzpj+hwPzq+i7K6zhpT_A@mail.gmail.com>
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

This is changing the semantics of the clone. Sorry, I missed this
thread and replied separately. But anyway, replying it again here:


On Wed, Aug 8, 2012 at 4:28 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Aug 06, 2012 at 07:16:33PM -0400, Mikulas Patocka wrote:
>> Hi Kent
>>
>> When you change the semantics of an exported function, rename that
>> function. There may be external modules that use __bio_clone and this
>> change could silently introduce bugs in them.
>>
>> Otherwise, the patchset looks fine.
>
> I don't know.  This doesn't change the main functionality and should
> be transparent unless the caller is doing something crazy.  It *might*
> be nice to rename but I don't think that's a must here.
>
> Thanks.

--
You are changing the meaning of __bio_clone() here. In old code, the
number of io_vecs, bi_idx, bi_vcnt are preserved. But in this modified
code, you are mapping bio_src's bi_iovec[bi_idx] to bio_dests
bi_iovec[0] and also restricting the number of allocated io_vecs of
the clone. It may be useful for cases were we would like a identical
copy of the original bio (may not be in current code base, but this
implementation is definitely not what one would expect from the name
"clone").

May be, call this new implementation some thing else (and use it for bcache)?

---

Like Mikulas pointed out, this is an exported function and silently
changing the semantics will break external modules.

Regards,
Muthu


>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
