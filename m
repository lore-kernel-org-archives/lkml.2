Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0INNIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:08:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41876 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab0INNIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XaMkCh3yLMFexjdvYvghufLNXt23E2qpb0qS8SH5hcgjPCrMbh4+QkBBL33IJkub5p
         2MU7BrbM19mOqXbB14eWbafmq63u4QUXK+z/y3hZpa7po9uwpmCID23DIPNahlzN8sJa
         kAc3jG1ss9xucVHhJLN7cTw5aap63JLgO3hkc=
Date: Tue, 14 Sep 2010 15:07:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/1] perf/core ui browser improvement
Message-ID: <20100914130753.GA5341@nowhere>
References: <1284395692-11298-1-git-send-email-acme@infradead.org> <20100913174845.GC18428@elte.hu> <20100913190758.GB31907@ghostprotocols.net> <20100913204217.GA2505@elte.hu> <20100913212951.GI31907@ghostprotocols.net> <1284450852.2275.458.camel@laptop> <20100914121611.GD12425@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914121611.GD12425@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 02:16:11PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2010-09-13 at 18:29 -0300, Arnaldo Carvalho de Melo wrote:
> > > +      3.00%         find  [kernel.kallsyms]   [k] n_tty_write
> > 
> > > +      3.00%         find  kernel       k n_tty_write
> > 
> > I find that [k] is visually easier to separate from the symbol name.
> 
> me too. Something like:
> 
> before:
> 
>      1.08%           cc1  libc-2.12.so                  [.] _int_malloc
>      0.94%           cc1  [kernel.kallsyms]             [k] clear_page_c
>      0.74%           cc1  libc-2.12.so                  [.] _int_free
>      0.69%           cc1  [kernel.kallsyms]             [k] page_fault
>      0.46%           cc1  libc-2.12.so                  [.] malloc_consolidate
> 
> after:
> 
>      1.08%           cc1  # libc-2.12.so                [.] _int_malloc
>      0.94%           cc1  # kernel                      [k] clear_page_c
>      0.74%           cc1  # libc-2.12.so                [.] _int_free
>      0.69%           cc1  # kernel                      [k] page_fault
>      0.46%           cc1  # libc-2.12.so                [.] malloc_consolidate
> 
> 
> Would largely do the trick i think. The comments delineate the DSO 
> portion from the task portion nicely - while also being a familar 
> pattern. The column of [.] and [k] gives kernel developers a quick 
> glance wrt. whether it's kernel or user-space - and it also delineates 
> the symbol column from the DSO column.
> 
> Thanks,
> 
> 	Ingo


<random ideas for the future>

BTW, having [u] instead of [.] would perhaps be more clearer?
And one day we might want to extend that with more granularity,
like major contexts in uppercase: K=kernel, U=user, H=hypervisor
and some minor in lowercase: h=hardirq, s=softirq, t=task.

So you can get [Kh], [Ks], etc...

User could then sort by context, which could be useful without
callchains for example.


</random ideas for the future>

