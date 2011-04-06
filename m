Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab1DFXqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 19:46:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47744 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab1DFXqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 19:46:35 -0400
Date: Thu, 7 Apr 2011 05:16:24 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 22/26] 22: perf: rename target_module
 to target
Message-ID: <20110406234213.GC5806@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143657.15455.4701.sendpatchset@localhost6.localdomain6>
 <4D99980E.5080807@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D99980E.5080807@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> > -int show_available_funcs(const char *module, struct strfilter *_filter)
> > +int show_available_funcs(const char *elfobject, struct strfilter *_filter)
> >  {
> >  	struct map *map;
> >  	int ret;
> > @@ -1990,9 +1990,9 @@ int show_available_funcs(const char *module, struct strfilter *_filter)
> >  	if (ret < 0)
> >  		return ret;
> >  
> > -	map = kernel_get_module_map(module);
> > +	map = kernel_get_module_map(elfobject);
> >  	if (!map) {
> > -		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
> > +		pr_err("Failed to find %s map.\n", (elfobject) ? : "kernel");
> 
> Hmm, these changes(module -> elfobject) are put back by the next patch.
> Could you check your patch stack?
> 

In the next patch, we move "map =
kernel_get_module_map(module/elfobject)" to a new function
available_kernel_funcs(). For example: Even after the next patch,
show_available_funcs() still takes elfobject and not module. If you want
to avoid this, then we would have to either introduce the
available_kernel_funcs() in this patch Or we could merge this and the
next patch. Both those solutions dont look clean to me.

-- 
Thanks and Regards
Srikar
