Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab2EXKma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:42:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:39131 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab2EXKm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:42:29 -0400
Subject: Re: [PATCH 02/16] perf: Add ability to attach registers dump to
 sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
In-Reply-To: <CABPqkBR9hewjNUJf9ByD-jHc42e_qwQiKoP68RyL7BU8Q7BGgQ@mail.gmail.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-3-git-send-email-jolsa@redhat.com>
	 <1337853048.9783.92.camel@laptop>
	 <CABPqkBR9hewjNUJf9ByD-jHc42e_qwQiKoP68RyL7BU8Q7BGgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 12:42:22 +0200
Message-ID: <1337856142.9783.104.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 12:06 +0200, Stephane Eranian wrote:

> > What are we doing here and why?
> >
> I think this is related to a discusion we had earlier about which
> machine state you want
> to sample.
> 
> There are 3 possible machine states:
>   1- user level (even when sample is in kernel AND assuming you did
> not hit a kernel only thread)
>   2- interrupted state (@ PMU interrupt)
>   3- precise state (state captured by PEBS on Intel, for instance)
> 
> Jiri is only interested in 1/. I am interested in the other two as well.
> 
> Question: is there a situation where we could need more than one machine
> state per sample?

Well, IIRC you always wanted both 2 and 3 at the same time to compute
skid, thus:

> If not, then a single bitmask is enough.

Indeed, so then we get to multiple bitmasks and unless you want to be
restricted to the same bitmap for all these types this setup won't
actually work.

Also, all that was missing from the changelog.



