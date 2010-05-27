Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab0E0Sln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:41:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59379 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759477Ab0E0Slm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Zxz9Sa+WwaUqUWRP1T7uM3vHQ2kVBYSCwuWX5d9v/MVkhNL1PaJaJlGyLNq/hL6hG8
         JXV9p4sCLPeQhLZniLnFMj1PZquAdNhIfIGDV7K+54+JNDWQnzOYsZYDARCMeD3WJeDr
         0mefOxVTwGl+qeKowPZ/HxX1Fhper7bslXkgg=
Date: Thu, 27 May 2010 15:41:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Arun Sharma <aruns@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com
Subject: Re: [PATCH] perf: implement recording/reporting per-cpu samples
Message-ID: <20100527184135.GL9874@ghostprotocols.net>
References: <20100503203813.GA17886@sharma-home.net>
 <1272919356.1642.154.camel@laptop>
 <w2u850c51c31005031353x9be8ca7h90c244d64675ce3e@mail.gmail.com>
 <1272964598.5605.133.camel@twins>
 <20100505181612.GA5091@sharma-home.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505181612.GA5091@sharma-home.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 05, 2010 at 11:16:12AM -0700, Arun Sharma escreveu:
> On Tue, May 04, 2010 at 11:16:38AM +0200, Peter Zijlstra wrote:
> > > In a shared multi-core environment, users want to analyze why their
> > > program was slow. In particular, if the code ran slower only on
> > > certain CPUs due to interference from other programs or kernel
> > > threads, they want to know that.
> > 
> > But for that you use perf record -a, right? So you record all cpus
> > allways -- otherwise there is no telling what was happening to make it
> > go slow.
> 
> The updated patch records the CPU only in the system_wide mode.

I think this should be done only if you'll actually need it, as in,
"cpu" is one of the sort keys, but that can be done as a followup patch,
but there is another thing I think you need to change, see below.

> > > But that's just our use case. The patch is mostly about --sort cpu
> > > option. If you want to drop the part that enables PERF_SAMPLE_CPU by
> > > default, that's fine by me.
> > 
> > Right, it would be very nice if we can avoid growing the default sample
> > size. Also, your changelog needs work, please explain the full usecase
> > that goes with this feature.
> > 
> > Explain the thing you're wanting to measure, explain the implementation
> > and maybe give a short example.
> 
> Updated changelog as well.
> 
>  -Arun
> 

<SNIP>

> +	if (session->sample_type & PERF_SAMPLE_CPU) {
> +		dump_printf("... cpu: %d\n", data.cpu);
> +		al.cpu = data.cpu;
> +	} else {
> +		al.cpu = -1;
> +	}
> +

This should be in event__parse_sample() that will set a field in
sample_data, just like the others optional fields.

I'll cook up a patch with these changes and post here for your review.

- Arnaldo
