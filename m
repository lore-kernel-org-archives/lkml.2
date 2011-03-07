Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1CGSUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:20:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:24040 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1CGSUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:20:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=iH2RS+rlKhvfaE6hy2yAcCzYIEVA9hENNsXuVwhjB9X35EtIoIXvp14w637U4Bye57
         qefnEYCviAQpCKa7b0KA==
MIME-Version: 1.0
In-Reply-To: <4D6F0ED0.80804@kernel.dk>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com> <4D6F0ED0.80804@kernel.dk>
From: Justin TerAvest <teravest@google.com>
Date: Mon, 7 Mar 2011 10:20:10 -0800
Message-ID: <AANLkTin+TycqQxWGyxWOsuT+WOaEA0XhqFkJBMKe7-uY@mail.gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 7:45 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-03-01 09:20, Vivek Goyal wrote:
>> I think creating per group request pool will complicate the
>> implementation further. (we have done that once in the past). Jens
>> once mentioned that he liked number of requests per iocontext limit
>> better than overall queue limit. So if we implement per iocontext
>> limit, it will get rid of need of doing anything extra for group
>> infrastructure.
>>
>> Jens, do you think per iocontext per queue limit on request
>> descriptors make sense and we can get rid of per queue overall limit?
>
> Since we practically don't need a limit anymore to begin with (or so is
> the theory), then yes we can move to per-ioc limits instead and get rid
> of that queue state. We'd have to hold on to the ioc for the duration of
> the IO explicitly from the request then.
>
> I primarily like that implementation since it means we can make the IO
> completion lockless, at least on the block layer side. We still have
> state to complete in the schedulers that require that, but it's a good
> step at least.

So, the primary advantage of using per-ioc limits that we can make
IO completions lockless?

I'm concerned that looking up the correct iocontext for a page will be more
complicated, and require more storage (than a css_id, anyway). I think Vivek
mentioned this too.

I don't understand what the advantage is of offering isolation between
iocontexts within a cgroup; if the user wanted isolation, shouldn't
they just create multiple cgroups? It seems like per-cgroup limits would work
as well.

Thanks,
Justin

>
> --
> Jens Axboe
>
>
