Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab1BRTGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:06:14 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47626 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1BRTGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:06:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=TrwtKLh7K8kuy9c7i0H6yj9a9qxXTgBMTFBHjvDASvAnSAY8O/lL8HFluFA6YkKqEt
         HpOCgJmkgXI8Isowcrz2PTTB8HzAefKhghj550EkkMOAvuowRWOEKqMH9kYe65ZBlzt0
         BB1dQdB+AvgonTARr8xavFfdxl9FwlJxr0jW8=
Date: Fri, 18 Feb 2011 17:06:06 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and report
Message-ID: <20110218190606.GD302@ghostprotocols.net>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
 <1298008433-22911-4-git-send-email-daahern@cisco.com>
 <20110218070657.GA11404@elte.hu>
 <4D5E8204.2090501@cisco.com>
 <20110218175926.GA3445@nowhere>
 <20110218184119.GC302@ghostprotocols.net>
 <4D5EC01C.1030108@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5EC01C.1030108@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 18, 2011 at 11:53:16AM -0700, David Ahern escreveu:
> On 02/18/11 11:41, Arnaldo Carvalho de Melo wrote:
> > Think about tcpdump + networking tracepoints or 'perf probe' dynamic
> > events in the network stack, he wants to merge those logs and correlate
> > the tcpdump packet exchange with the tracepoints events in the network
> > stack, etc.

> I'm zoned in on ap logs, but tcpdump and network analysis is another
> very good example. packets are tagged with realtime:

> static inline void __net_timestamp(struct sk_buff *skb)
> {
>     skb->tstamp = ktime_get_real();
> }

I'd bet the original intent was to merge that with app specific logs :-)

Anyway, I think the way out of this is to have a clock_gettime like
interface, let the users decide what they need (or think they do),
sample it together with the other events and be done with it.

- Arnaldo
