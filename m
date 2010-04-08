Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab0DHVRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:17:42 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:58171 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038Ab0DHVRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BIGP3yiXNO0ls7Qrv3EGMXkg5kdBXUWQ6hehRPet//Em45lUksnmLYo7P+2zK2iybo
         Mv6mTc61aTeMSeY2UoA0XJcJ3W0fapzSb/Z8RtV2BdoLIHPw9KuXJQgh2RKfHP/FWvj+
         JVy2G6EvnErWrnVHyxmx6BhlKmIO8n5yImEQA=
Date: Thu, 8 Apr 2010 23:17:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       robert.richter@amd.com, perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in
	perf_prepare_sample()
Message-ID: <20100408211727.GA7990@nowhere>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com> <1270760136.20295.3121.camel@laptop> <v2xbd4cb8901004081408mf761d04ag5a365d068c58d64b@mail.gmail.com> <1270761083.20295.3158.camel@laptop> <g2rbd4cb8901004081414l505e6b04td902794f381224af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g2rbd4cb8901004081414l505e6b04td902794f381224af@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 11:14:15PM +0200, Stephane Eranian wrote:
> On Thu, Apr 8, 2010 at 11:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2010-04-08 at 23:08 +0200, Stephane Eranian wrote:
> >>
> >> Are you suggesting you add some padding the PEBS raw sample you
> >> return as PERF_SAMPLE_RAW? Then you need to define what RAW
> >> actually means? Seems here, it would mean more than what the
> >> HW returns.
> >
> > Well, RAW doesn't mean anything much at all, its really a fugly pass
> > some crap around thing.
> >
> > So yeah, adding padding seems just fine.
> >
> I would rather see size as u64. Who's using raw today anyway?


The trace events. Hence the size of the size shouldn't be touched, it
is an ABI now.

