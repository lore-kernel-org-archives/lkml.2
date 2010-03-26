Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0CZRnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:43:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37089 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0CZRnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:43:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dfMH3G9aMBChhNtl7zolzNfT+LRFMuFSSEtrHWy5Olt2z4FiW1n4T61P1U7mHLJrGq
         lOFqZTpwK8FZzPcAmARoBdBFb92iJoI5KZMgPaVxMsnviixxmAXCZKMq8R6MsKG555jh
         710FyCxQz7fYyFrhhfGoNk7eGA2JCeokRUMwk=
Date: Fri, 26 Mar 2010 18:43:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: Make lockstats counting per cpu
Message-ID: <20100326174318.GF5188@nowhere>
References: <1269570142-13965-1-git-send-regression-fweisbec@gmail.com> <1269586358.12097.117.camel@laptop> <1269589714.12097.122.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269589714.12097.122.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 08:48:34AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-03-26 at 07:52 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-03-26 at 03:22 +0100, Frederic Weisbecker wrote:
> > > We can't use irqsafe per cpu counters for that as
> > > these stats might be also written from NMI path, and irqsafe per
> > > cpu counters are not NMI safe, but local_t operations are.
> > > 
> > lockdep shouldn't do NMI, nmi_enter() has an explicit lockdep_off().
> 
> Also, more importantly, you simply should never use locks in NMI context
> to begin with ;-)


Right. I just thought ther could be some path that use rcu_read_lock
things there or whatever check. I mean, NMI don't need rcu_read_lock
but it could call helpers that use it.

Whatever, lockdep is off there. Looks like I can safely use per cpu counters.

