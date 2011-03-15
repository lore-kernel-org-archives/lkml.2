Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1COJIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:08:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:41491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1COJIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:08:06 -0400
Subject: Re: perf: kernel memory leak when inherit enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <alpine.DEB.2.00.1103141824190.13179@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1103111745070.15818@cl320.eecs.utk.edu>
	 <alpine.DEB.2.00.1103141824190.13179@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Mar 2011 10:07:57 +0100
Message-ID: <1300180077.2203.56.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 18:27 -0400, Vince Weaver wrote:
> On Fri, 11 Mar 2011, Vince Weaver wrote:
> > 
> > While trying to use perf events with inherit enabled to profile some 
> > multi-threaded BLAS routines (using PAPI) I ended up out-of-memorying my 
> > machine.  It turns out you can quickly leak gigabytes of kernel memory
> > that isn't freed when the process exits.
> 
> I've bisected this.  There's a whole day I'll never see again. binutils 
> 2.21 and gcc-4.5 for the lose :(
> 
> Anyway this memory leak with inherit was introduced in 
>   4fd38e4595e

Thanks, managed to get some time yesterday and got as far as to see that
our perf_event_context refcounting is indeed screwy, but didn't get
around to actually catching the culprit.


