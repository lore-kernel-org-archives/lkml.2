Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab0CQCIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:08:00 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:32986 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab0CQCH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M9zw+FUyhQ1dQzz3ZUzk+Fg3c5KRL5lgRgkQWM97Xv4A/RzvNuRBZXbIfCApCb5hTU
         G6Vhhs3EoCWF7ySZrPR9oPt0P8rTRVFalN64ntimMq5GcJiOejtcRqbzLYqxEfyRKV4i
         cPEpNvEzgoE3XqOLyYHmnjDdQ+X8B1feIE0Gs=
Date: Wed, 17 Mar 2010 03:08:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       stable@kernel.org
Subject: Re: [PATCH 5/5] tracing: Do not record user stack trace from NMI
	context
Message-ID: <20100317020759.GE5258@nowhere>
References: <20100313025655.104950166@goodmis.org> <20100313025855.495916344@goodmis.org> <20100314102747.GB5140@nowhere> <1268585920.13400.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268585920.13400.14.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 12:58:40PM -0400, Steven Rostedt wrote:
> On Sun, 2010-03-14 at 11:27 +0100, Frederic Weisbecker wrote:
> 
> > 
> > Wow, that's a race :)
> > 
> > In perf this is dealt with a special copy_from_user_nmi()
> > (see in arch/x86/kernel/cpu/perf_event.c)
> > 
> > May be save_stack_trace_user() should use that instead
> > of a __copy_from_user_inatomic() based thing, just to
> > cover such NMI corner race case.
> > 
> 
> Yeah, we should move the __copy_from_user_nmi() out of the perf code and
> into the normal uaccess code. Then we could do as you suggest, and have
> the stack code do:
> 
> if (in_nmi())
> 	__copy_from_user_nmi();
> else
> 	__copy_from_user_inatomic();
> 
> Or maybe it would be best to have the __copy_from_user_inatomic() handle
> it.


Yeah, agreed.

