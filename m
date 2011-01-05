Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1AEVU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:20:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab1AEVU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:20:26 -0500
Date: Wed, 5 Jan 2011 16:19:45 -0500
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, peterz@infradead.org,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: introduce static_branch()
Message-ID: <20110105211944.GG2896@redhat.com>
References: <cover.1294239591.git.jbaron@redhat.com> <2d8c38bd7ca93e162aedb8e7acfc8bdb96d85de2.1294239591.git.jbaron@redhat.com> <20110105171516.GB1692@nowhere> <1294249596.26623.38.camel@gandalf.stny.rr.com> <4D24BDD5.5090803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D24BDD5.5090803@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 10:52:05AM -0800, H. Peter Anvin wrote:
> On 01/05/2011 09:46 AM, Steven Rostedt wrote:
> > On Wed, 2011-01-05 at 18:15 +0100, Frederic Weisbecker wrote:
> >> On Wed, Jan 05, 2011 at 10:43:12AM -0500, Jason Baron wrote:
> >>> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> >>> index 152f7de..0ad9c2e 100644
> >>> --- a/include/linux/jump_label.h
> >>> +++ b/include/linux/jump_label.h
> >>> @@ -22,6 +22,11 @@ struct module;
> >>>  
> >>>  #ifdef HAVE_JUMP_LABEL
> >>>  
> >>> +static __always_inline bool static_branch(struct jump_label_key *key)
> >>> +{
> >>> +	return __static_branch(key);
> >>
> >> Not very important, but __static_branch() would be more self-explained
> >> if it was called arch_static_branch().
> > 
> > I disagree, I think it is very important ;-)
> > 
> > Yes, the kernel has been moving to adding "arch_" to functions that are
> > implemented dependently by different archs. Please change this to
> > "arch_static_branch()".
> > 
> 
> Indeed.  This hugely simplifies knowing where to look and whose
> responsibility it is.
> 
> 	-hpa

agreed. updated.

thanks,

-Jason
