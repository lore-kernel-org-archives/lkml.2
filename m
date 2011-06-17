Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab1FQPPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:15:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56947 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab1FQPPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LpKNXxQpGWEeyhWotZQYZ0DSGmMJa8Bi7YRTk2h9etMClbR1Am7mfsytOpqsnKsZ0M
         TPlt1k47AEdZhktMRhfwbKQQVXu6fI5tc5i0eSELGv05mF/TxTVEUlfzUnL3cbPzV/i8
         Jq73MqS0La0ICoDQfkRrutskpGkcDZp/DnS5U=
Date: Fri, 17 Jun 2011 17:15:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 4/6] perf record: add time-of-day option
Message-ID: <20110617151510.GG25197@somewhere.redhat.com>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
 <1307490964-24714-1-git-send-email-dsahern@gmail.com>
 <20110617141425.GD25197@somewhere.redhat.com>
 <4DFB6345.3080007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB6345.3080007@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 08:23:01AM -0600, David Ahern wrote:
> On 06/17/2011 08:14 AM, Frederic Weisbecker wrote:
> > 
> > So I feel uncomfortable with this tod_sample_type hack. I think we can't really continue
> > with this fixed sample_type per session given the kind of hacks that involves.
> > 
> > One thing we could do is to split session->sample_type into an array with one sample
> > type per event type (hardware, breakpoint, software, tracepoint).
> > 
> > And then each builtin tool can provide their constraints on top of these values:
> > 
> > - builtin-report wants sample_type[HARDWARE] == sample_type[SOFTWARE] == sample_type[TRACEPOINT] == sample_type[BREAKPOINT]
> >   although that may be tunable by the time but we can start with that.
> > - builtin-script has no specific constraints, except that sample_type[i] meets what the user passed as a parameter
> > - etc..
> > 
> > Constraints can probably default to sample_type[i] == sample_type[i+1] to mimic the current behaviour. Then tools
> > can override that.
> > 
> > What do you think?
> 
> I started working on sample_type refactoring right after sending this
> patchset (though I got sidetracked). Each evsel in the list has a
> perf_attr struct which has a sample_type. Why not use that which allows
> events to have their own sample type - versus a type per event type?

This can make sense, I can figure out some cases where such granularity can be
useful. Branch recording doesn't care about recording period for example I think.

> 
> I'll see if I can get back to it in the next few days and get a better
> idea of the pain involved with the refactoring.

Thanks a lot :)
