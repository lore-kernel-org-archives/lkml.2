Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2EWNGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:06:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56234 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747Ab2EWNGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:06:46 -0400
MIME-Version: 1.0
In-Reply-To: <1337761273.9698.60.camel@twins>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
	<1337081295-10303-5-git-send-email-eranian@google.com>
	<4FB32032.3000509@gmail.com>
	<CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
	<4FB67DE5.8050000@gmail.com>
	<20120518171911.GH2636@infradead.org>
	<1337708035.9698.44.camel@twins>
	<CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
	<1337761273.9698.60.camel@twins>
Date: Wed, 23 May 2012 15:06:44 +0200
Message-ID: <CABPqkBQm2oKzTES8VSai-O9G9Ag1TzZZznR2wEHeWouRY3ZrXQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:21 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-05-22 at 19:51 +0200, Stephane Eranian wrote:
>> The problem is that the headers as they are written to the file need
>> seeking in the file to update the offset table. That is NOT possible when
>> you operate in pipe mode.
>
> I know that, I said as much. But it is quite possible to multiplex
> streams without the need for seeking, look at these MKV containers that
> contain video, multiple-audio and multiple-subtitle tracks.
>
> The fact is, whomever wrote that pipe mode took a bonghit before
> touching the keyboard. They didn't even ask if we could reserve a range
> for userspace events, let alone consider if it was a good idea to begin
> with.
You're probably right, but the fact of the matter is, it's there now and
we have lots of perf.data piling up all over the place. So you need
to maintain compatibility with those. In my patch, I am just extending
what's already there. I was not trying to rewrite the whole pipe mode + meta
data logic (though I have done some of that already in the past).

Clearly pipe-mode was an after thought, but it is useful, I know people who
use it. Obviously I use it, otherwise I would not necessarily have spent the
time fixing the meta-data headers.

But I think, for the time being, my patch addresses an issue and does
not prevent us for discussing a new file format for perf record, I have nothing
against that.


>
> If we ever manage to get splice() working you can't keep that pipe mode
> working anyway.
>
> Pushing everything over a single stream isn't a scalable solution anyway
> in the same way that writing everything into the one file isn't the best
> thing and would ideally be replaced as well.
