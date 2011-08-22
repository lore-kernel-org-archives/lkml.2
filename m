Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1HVQH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:07:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1HVQH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:07:26 -0400
Date: Mon, 22 Aug 2011 18:07:13 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tool, record: Fix the header generation for pipe
Message-ID: <20110822160713.GA10134@jolsa.brq.redhat.com>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
 <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110822145210.GA8694@jolsa.brq.redhat.com>
 <1314028266.2307.93.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1314028266.2307.93.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 05:51:06PM +0200, Eric Dumazet wrote:
> Le lundi 22 août 2011 à 16:52 +0200, Jiri Olsa a écrit :
> 
> > - fd is always file.. the descriptor, which might be pipe, is in output_fd variable
> >   but, maybe the die call is not necessary.. this should not fail
> > 
> > - the record_file function is called only on debugfs or procfs files:
> > 	events/header_page
> > 	events/header_event
> > 	events/**/format
> > 	printk_formats
> > 	/proc/kallsyms
> > 
> > so I think I need to read the whole file as in current code.
> > 
> 
> You read the file twice. Is it the right fix ?
> 
> Once to compute the length to be able to write the output header, once
> to process the content.
> 
> Are you sure length cannot change between the two phases ?
> 
> /proc/kallsyms can definitely change when a module is loaded.

Right, better to store it to a temp file as you suggest,
so we have consistent view.. I'll prepare new patch.

thanks,
jirka


> 
> Usually, when input "file" is not seekable or procfs based (fstat()
> returns st_size=0), we must load/cache it in memory (or using a
> temporary file) to get a consistent view of it.
> 
> This is what is done by following commands :
> 
> cat /proc/kallsyms | less
> less /proc/kallsyms
> 
> 
> 
