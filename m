Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0ESJDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:03:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58153 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0ESJDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fsRnlUiAtGDyaxsGmRYksE5wnP9BJXJsMRYXl7imEIlR9ROt+dYfnVjzjcnrYi/iVR
         0uRxObv3NZcFWQW2nCY9UHQyxL8vQXMHk6R4oi86K6FA/fXJtAiMp+7qXLeQoi7pywDl
         KWpSfEQC0/NmfpEpUfHFHbTVsGN0PjYt6jmPI=
Date: Wed, 19 May 2010 11:03:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] perf: Implement perf_output_addr()
Message-ID: <20100519090319.GJ5704@nowhere>
References: <20100518133258.000434886@chello.nl> <20100518133726.214318408@chello.nl> <20100519072138.GC5704@nowhere> <1274255882.5605.10216.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274255882.5605.10216.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 09:58:02AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 09:21 +0200, Frederic Weisbecker wrote:
> 
> > I'm still not sure what you mean here by this multiplexing. Is
> > this about per cpu multiplexing?
> 
> Suppose there's two events attached to the same tracepoint. Will you
> write the tracepoint twice and risk different data in each, or will you
> do it once and copy it into each buffer?



The only different data we risk in each is the timestamp, which is
something we can probably fetch once before actually filling the
buffers.


 
> > There is another problem. We need something like
> > perf_output_discard() in case the filter reject the event (which
> > must be filled for this check to happen).
> 
> Yeah, I utterly hate that, I opted to let anything with a filter take
> the slow path. Not only would I have to add a discard, but I'd have to
> decrement the counter as well, which is a big no-no.


That makes it complicated. But for now we don't have much other solutions.

