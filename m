Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2IYL22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:28:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:57780 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2IYL21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:28:27 -0400
Date: Tue, 25 Sep 2012 08:28:18 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 28/30] perf evsel: Provide a new constructor for
 tracepoints
Message-ID: <20120925112818.GE28902@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
 <1348502384-14442-29-git-send-email-acme@infradead.org>
 <874nmmybg9.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nmmybg9.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 01:26:46PM +0900, Namhyung Kim escreveu:
> On Mon, 24 Sep 2012 12:59:42 -0300, Arnaldo Carvalho de Melo wrote:
> > +		if (size == alloc_size) {
> > +			alloc_size += BUFSIZ;
> > +			nbf = realloc(bf, alloc_size);
> > +			if (nbf == NULL)
> > +				goto out_free_bf;
> > +			bf = nbf;
> > +		}
> > +
> > +		n = read(fd, bf + size, BUFSIZ);
> 
> Wouldn't it be better doing s/BUFSIZ/alloc_size - size/ ?  Although
> there'll be no partial reading issue when working on debugfs I guess.

Yeah, don't know if that is worth it :-\

- Arnaldo
