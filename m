Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab1CPNxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:53:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40196 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1CPNxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G+OP755bz2cty0DwHNqJ3PXGLDmK06QYNgjEb6385XM/px4QjJ51388+ESQV0s72hG
         bnDrjh312JtOvzrILLH8vU24QUr74Kz+vLyVFz38SyLBrPBB/Yed/pnxTAKCpYdWd0pI
         PGPbUd8b5wrrNRvBYgXu9kaMGC1io2P5yb4YA=
Date: Wed, 16 Mar 2011 14:53:15 +0100
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
Message-ID: <20110316135308.GA1774@nowhere>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <1300228374.2250.42.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300228374.2250.42.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 11:32:54PM +0100, Peter Zijlstra wrote:
> Right, so I don't much like the interface, two new ioctl()s and a flag
> of dubious use.

Do you think we need a new syscall for this new feature.
 
> How important is this recursive nature of the thing to you:
> 
> > It's supposed to support infinite combinations with starter having starters
> > themselves, plus filters, etc...
> 
> We've so far avoided recursion like that, we only have single level
> groups etc.

There is actually no recursivity of any sort that the kernel has to handle.
The starter/stopper links are never handled recursively. ie: there is no
loop walking through the entire chain of starter to starter to starter, etc...

It's always only handled between direct related event: starter and target, but
never further.

Only the final effect has recursion properties in the resulting count
or trace.
