Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab2EWIV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:21:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33461 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab2EWIVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:21:24 -0400
Message-ID: <1337761273.9698.60.camel@twins>
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Date: Wed, 23 May 2012 10:21:13 +0200
In-Reply-To: <CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
	 <1337081295-10303-5-git-send-email-eranian@google.com>
	 <4FB32032.3000509@gmail.com>
	 <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
	 <4FB67DE5.8050000@gmail.com> <20120518171911.GH2636@infradead.org>
	 <1337708035.9698.44.camel@twins>
	 <CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 19:51 +0200, Stephane Eranian wrote:
> The problem is that the headers as they are written to the file need
> seeking in the file to update the offset table. That is NOT possible when
> you operate in pipe mode. 

I know that, I said as much. But it is quite possible to multiplex
streams without the need for seeking, look at these MKV containers that
contain video, multiple-audio and multiple-subtitle tracks.

The fact is, whomever wrote that pipe mode took a bonghit before
touching the keyboard. They didn't even ask if we could reserve a range
for userspace events, let alone consider if it was a good idea to begin
with.

If we ever manage to get splice() working you can't keep that pipe mode
working anyway.

Pushing everything over a single stream isn't a scalable solution anyway
in the same way that writing everything into the one file isn't the best
thing and would ideally be replaced as well.
