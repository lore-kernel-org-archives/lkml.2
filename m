Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab0JRBga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 21:36:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63234 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab0JRBg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 21:36:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YzbVRVnpolCVauJegfBdzKXGeGCLVleIUxBz6SwcfLCUhsbO3ptreE2mxlh20V70WH
         amasQ3U0ag2plDCW+RcPC5fnNiVvKIQh7t7TJkld4EqZQDh1mRDH9kVV+qmRWzKiFbbG
         G5pieYv1vi21Le6gQSo7AnUKkNKTQMgJck67g=
Date: Mon, 18 Oct 2010 03:36:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.36-rc5-mmotm0928 BUG while trying to ptrace a process
Message-ID: <20101018013622.GA21722@nowhere>
References: <108598.1286357577@localhost> <1286372708.2144.183.camel@laptop> <20101018102609.3ADF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018102609.3ADF.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:28:43AM +0900, KOSAKI Motohiro wrote:
> > On Wed, 2010-10-06 at 05:32 -0400, Valdis.Kletnieks@vt.edu wrote:
> > > Dell Latitude E6500,  Intel Core2 Duo P8700 CPU.
> > > 
> > > Have seen this three times now while trying to attach gdb to a hung Firefox
> > > process.
> > > 
> > > [20669.480674] BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
> > > [20669.480682] IP: [<ffffffff810b8275>] __reserve_bp_slot+0x56/0x17d
> > 
> > Known issue I think, Frederic was looking into curing this.
> > 
> > Frederic, what's the current status of that?
> 
> mmotm1014 seems still have this issue. Frederic, can you please tell us
> current status if you are tracking this issue?


Peter has a pending queue for .37 which includes:

	[RFC][PATCH 3/7] perf, hw_breakpoint: Fix crash in hw_breakpoint creation

This patch should fix the issue (it depends on others in the queue).

What is mmotm1014 BTW? Because you should see this bug only in a tree
that has tip:/perf/core merged inside, like linux-next.

Thanks.

