Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab1CPODN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:03:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63029 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1CPODB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e4vEjVAZD/4LMMtDRuNAv8MtEdFjVxK0EWETfa5TvduzAMtUAkKnyNEWC0T+WO+Q5b
         ou4nDjxe8AM8OWRSNNmGOtdfz4FjkkF1DzztSd2B5AOzOh79WTtn5QryaO6D4zgc/VW/
         xnBTqMUBzpnk95HyxVjUylWOoGDRQDJq65Kzo=
Date: Wed, 16 Mar 2011 15:02:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
Message-ID: <20110316140242.GB1774@nowhere>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <1300228374.2250.42.camel@laptop>
 <20110316135308.GA1774@nowhere>
 <1300283775.2203.1516.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300283775.2203.1516.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 02:56:15PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-03-16 at 14:53 +0100, Frederic Weisbecker wrote:
> > On Tue, Mar 15, 2011 at 11:32:54PM +0100, Peter Zijlstra wrote:
> > > Right, so I don't much like the interface, two new ioctl()s and a flag
> > > of dubious use.
> > 
> > Do you think we need a new syscall for this new feature.
> 
> No.
> 
> > > How important is this recursive nature of the thing to you:
> > > 
> > > > It's supposed to support infinite combinations with starter having starters
> > > > themselves, plus filters, etc...
> > > 
> > > We've so far avoided recursion like that, we only have single level
> > > groups etc.
> > 
> > There is actually no recursivity of any sort that the kernel has to handle.
> > The starter/stopper links are never handled recursively. ie: there is no
> > loop walking through the entire chain of starter to starter to starter, etc...
> > 
> > It's always only handled between direct related event: starter and target, but
> > never further.
> > 
> > Only the final effect has recursion properties in the resulting count
> > or trace.
> 
> That's not an answer to my question.


Well, since there is no recursivity involved, there should be ne more worries
about allowing or not starters on starters. And I think it's an important
feature, that's in fact one of its key properties that let's one able to
define whatever kind of precise stacked context.

The possible usecase is so wide that I have a hard time to find a good
example. Counting instructions in exceptions on some specific syscalls,
counting instructions when some lock is taken on some irq handler, or
whatever...
