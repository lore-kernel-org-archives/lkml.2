Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1CPRxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:53:24 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43545 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1CPRxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=nJU/ntl2RiHCAwSwRAe3zPjSqj75Sfbo6mj4R2Kt6h5Rfl4Y6vMTH6/BNLnFRuYHU9
         N+dPxOQcQOZaLo07TGIrZLoq21FoXYF/XflgIu1YZTA+p/ljFUji1Ex4r9cmFvu3SqJ6
         2uxkVEiEgNxgQ9KHepzoPhhH8MulSZ6qfT8sU=
Date: Wed, 16 Mar 2011 14:53:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
Message-ID: <20110316175310.GA2861@ghostprotocols.net>
References: <20110314205100.GG6139@nowhere>
 <20110314210315.GC2388@ghostprotocols.net>
 <20110314212050.GH6139@nowhere>
 <20110314215603.GD2388@ghostprotocols.net>
 <20110314224344.GA11443@nowhere>
 <20110314230211.GG2388@ghostprotocols.net>
 <20110315185812.GB6605@nowhere>
 <20110315192422.GF7011@ghostprotocols.net>
 <20110316010304.GB7760@nowhere>
 <4D80DB75.6060408@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D80DB75.6060408@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 17, 2011 at 12:47:01AM +0900, Masami Hiramatsu escreveu:
> (2011/03/16 10:03), Frederic Weisbecker wrote:
> > Doh you're right. && would have two meaning.
> > No we should probably keep  a && b  has a meaning of we are
> > in the range a AND in the range b. Both at the same time, with
> > a evaluated first and then b. We also need to ensure than
> > a && b  doesn't mean the same than  b && a. You're right, perhaps
> > we need another operator to expression inclusion, or we need to
> > assume that specific meaning of &&.
> > 
> > For what I wanted to express in the example above, || seem be the
> > right choice: -e inst*@(..lock:*acquire(B) || lock:*release(B)..)
> > 
> > So || would mean union and && would mean inclusion.
> 
> Hmm, would we really need that kind of complex rules?
> It seems that we only need union case. If so, I'd suggest
> you to use ',' to express that, instead of ||.
> 
> -e inst*@(..lock:*acquire(B),lock:*release(B)..)

Yeah, I somehow was avoiding the comma operator because it could be used
to represent multiple events, but then its a different context, using it
to represent a circular list of ranges in the @ (at, location) expression
seems ok.

1. '..lock:*acquire(B)' is armed, 'lock:*release(B)..' isn't
2. '..lock:*acquire(B)' trigers, which causes 'lock:*release(B)..' to be
   armed
3. 'lock:*release(B)..' triggers, which causes '..lock:*acquire(B)' to
   be armed, rinse, repeat

- Arnaldo
