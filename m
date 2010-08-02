Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0HBSl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:41:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36118 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab0HBSlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HNZBDrX5YvT8iIaFfxtbUNVuYI49jILlrCsN20cH5wQFsWTHx6BGE6ltBtkDCMkNho
         eVIZQaxO/BgixVJizZmXqgSxydD1mP++xkYBEOl5WOJ7cYHk6uIaCVyrMRmmP8mpSboG
         0TJ7YnNwYBe0i2rYD6Qpfq5SDMYdPL3lFCTqg=
Date: Mon, 2 Aug 2010 20:41:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Markus Metzger <markus.t.metzger@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] BTS based perf user callchains
Message-ID: <20100802184149.GB8962@nowhere>
References: <20100802183506.GA8962@nowhere> <1280774332.1923.245.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280774332.1923.245.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 08:38:52PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-08-02 at 20:35 +0200, Frederic Weisbecker wrote:
> > I'm not even sure that will work. Also, while looking at the BTS implementation
> > in perf, I see we have one BTS buffer per cpu. But that doesn't look right as
> > the code flow is not linear per cpu but per task. Hence I suspect we need
> > one BTS buffer per task. But may be someone tried that and encountered a
> > problem? 
> 
> IIRC we flush the buffer when we deschedule the counter.


Ok. So the buffer is cut on schedule time. It might be nice
to maintain the buffer progress across scheduling.

That requires one buffer per task though. That could be worth.

