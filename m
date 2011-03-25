Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1CYShx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:37:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39995 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab1CYShv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=RT5SnZrA23fng1R23rZT85V7z0XhuWi8Sy9DBSTCggbWYu5KjT0vD2J0NKptEWdaVD
         haoic2zgKdOT83lTjA/rWNGCqBQD1UnOrGg8dMa4RyWVh1etnaSraAJNI5/7r0+xdYUb
         s+ONHzDYL9qt8zKsOjnC2Bmrb9evx8Ro5mNLo=
Date: Fri, 25 Mar 2011 15:37:45 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Emit clearer message for sys_perf_event_open
 ENOENT return
Message-ID: <20110325183745.GF13180@ghostprotocols.net>
References: <1301076350-19593-1-git-send-email-daahern@cisco.com>
 <20110325180840.GE13180@ghostprotocols.net>
 <4D8CDE61.6050400@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8CDE61.6050400@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 25, 2011 at 12:26:41PM -0600, David Ahern escreveu:
> On 03/25/11 12:08, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Mar 25, 2011 at 12:05:50PM -0600, David Ahern escreveu:
> >> Resend of patch sent back in January 2011 in light of recent confusion around
> >> unsupported events for a given platform.
> >>
> >> Improve sys_perf_event_open ENOENT return handling in top and record, just
> >> like 5a3446b does for stat.
> >>
> >> Retry of Arnaldo's patch using error instead of die which allows the fallback
> >> from hardware cycles to software clock.
> > 
> > Please use ui__warning(""...) as it will work in the TUI too.
> 
> error() is consistent with current pattern. Is ui__warning the
> preference for new messages? Is that for perf-top only?

Yes, it is, it takes care of using TUI of doing it like error() does.
Eventually error(), etc will go away.

- Arnaldo
