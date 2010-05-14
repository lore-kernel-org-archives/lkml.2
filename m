Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab0ENHyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:54:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:57372 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab0ENHyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:54:20 -0400
Subject: Re: Perf and ftrace [was Re: PyTimechart]
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
In-Reply-To: <20100513163150.GA13005@Krystal>
References: <20100512175305.GB32496@Krystal>
	 <1273687212.1626.147.camel@laptop> <20100512180438.GE15953@Krystal>
	 <1273687712.1626.151.camel@laptop> <20100512183704.GD21432@Krystal>
	 <1273690012.27703.38.camel@gandalf.stny.rr.com>
	 <20100512202745.GK21432@Krystal>
	 <1273702886.27703.58.camel@gandalf.stny.rr.com>
	 <20100513132029.GA22799@Krystal>
	 <1273765337.27703.1043.camel@gandalf.stny.rr.com>
	 <20100513163150.GA13005@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 May 2010 09:53:51 +0200
Message-ID: <1273823631.5605.3614.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 12:31 -0400, Mathieu Desnoyers wrote:
> 
> In addition, this would play well with mmap() too: we can simply add a
> ring_buffer_get_mmap_offset() method to the backend (exported through another
> ioctl) that would let user-space know the start of the mmap'd buffer range
> currently owned by the reader. So we can inform user-space of the currently
> owned page range without even changing the underlying memory map. 

I still think keeping refs to splice pages is tricky at best. Suppose
they're spliced into the pagecache of a file, it could stay there for a
long time under some conditions.

Also, the splice-client (say the pagecache) and the mmap will both want
the pageframe to contain different information.
