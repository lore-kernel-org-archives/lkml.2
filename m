Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1CPN44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:56:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:52271 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1CPN4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:56:49 -0400
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20110316135308.GA1774@nowhere>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
	 <1300228374.2250.42.camel@laptop>  <20110316135308.GA1774@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Mar 2011 14:56:15 +0100
Message-ID: <1300283775.2203.1516.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 14:53 +0100, Frederic Weisbecker wrote:
> On Tue, Mar 15, 2011 at 11:32:54PM +0100, Peter Zijlstra wrote:
> > Right, so I don't much like the interface, two new ioctl()s and a flag
> > of dubious use.
> 
> Do you think we need a new syscall for this new feature.

No.

> > How important is this recursive nature of the thing to you:
> > 
> > > It's supposed to support infinite combinations with starter having starters
> > > themselves, plus filters, etc...
> > 
> > We've so far avoided recursion like that, we only have single level
> > groups etc.
> 
> There is actually no recursivity of any sort that the kernel has to handle.
> The starter/stopper links are never handled recursively. ie: there is no
> loop walking through the entire chain of starter to starter to starter, etc...
> 
> It's always only handled between direct related event: starter and target, but
> never further.
> 
> Only the final effect has recursion properties in the resulting count
> or trace.

That's not an answer to my question.
