Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2BFPC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:02:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46531 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2BFPCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:02:55 -0500
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
In-Reply-To: <CABPqkBSuQCJkmJYbno_qsb=erOOf3uf84sQsSCzoov-6=7r40Q@mail.gmail.com>
References: <20120202211709.GA1642@x4> <20120202213220.GB1642@x4>
	 <CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
	 <20120204135110.GA6437@elte.hu>
	 <CABPqkBTvoNBBdzvS-njoFk+SrTf-BKQSvP54C05un+m7RA+nBg@mail.gmail.com>
	 <CABPqkBQdRwKKAvgK339Po0-WBW-MJkgcmpWqS=OOgepn3_XiRw@mail.gmail.com>
	 <1328523130.2220.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CABPqkBQLn+5fYtOjhpKjXSzvKesuo+YRXxaawyTGUTQuZ6AjYw@mail.gmail.com>
	 <1328526691.2220.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CABPqkBQnDToQczbgW4dCXiu3x2ZTXjAuKS_q_hJ=28Pu_2HexQ@mail.gmail.com>
	 <1328538568.2482.5.camel@laptop>
	 <CABPqkBSuQCJkmJYbno_qsb=erOOf3uf84sQsSCzoov-6=7r40Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 16:02:48 +0100
Message-ID: <1328540568.2482.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 15:32 +0100, Stephane Eranian wrote:
> I am wondering why we stop and restart the code in perf_adjust_period()
> when it's called from __perf_event_overflow(). Isn't it supposed to be stopped
> already by the model specific interrupt handler. Looks like we do stop/start,
> just to get the reload aspect of start. Is that right? 

Yes it is in order to deal with the case where an excessively long
period is programmed and we want to force load the new period without
having to wait for the old one to complete.

I hit that case several times with the adaptive code and events that
have very uneven rates.

