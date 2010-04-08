Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab0DHVmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:42:53 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33062 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759135Ab0DHVmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:42:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LQlpEuTHHyG3YfklUiT8IjCCB9vlOExN8/AKI2p8FXM2DewdTebjeodkqORxnTBR8K
         uWo+miuhZumv8h56kR8L3/mN8lYEVlV82CGADY4sOOZbzn7c6HN0Omt0siUxHjJ9InSW
         pib1xk1gAOUsayg+t/n6Rk6WzONp104bascWk=
Date: Thu, 8 Apr 2010 23:42:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       robert.richter@amd.com, perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in
	perf_prepare_sample()
Message-ID: <20100408214241.GC7990@nowhere>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com> <1270760136.20295.3121.camel@laptop> <v2xbd4cb8901004081408mf761d04ag5a365d068c58d64b@mail.gmail.com> <1270761083.20295.3158.camel@laptop> <g2rbd4cb8901004081414l505e6b04td902794f381224af@mail.gmail.com> <20100408211727.GA7990@nowhere> <u2nbd4cb8901004081422pe7088569s430734577b576b43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u2nbd4cb8901004081422pe7088569s430734577b576b43@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 11:22:05PM +0200, Stephane Eranian wrote:
> On Thu, Apr 8, 2010 at 11:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Thu, Apr 08, 2010 at 11:14:15PM +0200, Stephane Eranian wrote:
> >> On Thu, Apr 8, 2010 at 11:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Thu, 2010-04-08 at 23:08 +0200, Stephane Eranian wrote:
> >> >>
> >> >> Are you suggesting you add some padding the PEBS raw sample you
> >> >> return as PERF_SAMPLE_RAW? Then you need to define what RAW
> >> >> actually means? Seems here, it would mean more than what the
> >> >> HW returns.
> >> >
> >> > Well, RAW doesn't mean anything much at all, its really a fugly pass
> >> > some crap around thing.
> >> >
> >> > So yeah, adding padding seems just fine.
> >> >
> >> I would rather see size as u64. Who's using raw today anyway?
> >
> >
> > The trace events. Hence the size of the size shouldn't be touched, it
> > is an ABI now.
> 
> Given your alignment constraints, it seems like it was a bad choice to pick
> u32 for size to begin with.


Indeed, I'm not exactly sure how this is dealt since this is indeed u32
and the buffer requires to align to u64...

