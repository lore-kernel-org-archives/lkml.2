Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab0G0LRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 07:17:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45235 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab0G0LRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:17:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 1/2] Add trace points to mmap, munmap, and brk
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        mingo@redhat.com, hugh.dickins@tiscali.co.uk, riel@redhat.com,
        peterz@infradead.org, anton@samba.org, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100727110904.GA6519@mgebm.net>
References: <20100721223359.8710.A69D9226@jp.fujitsu.com> <20100727110904.GA6519@mgebm.net>
Message-Id: <20100727201644.2F46.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 27 Jul 2010 20:17:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 21 Jul 2010, KOSAKI Motohiro wrote:
> 
> > > This patch adds trace points to mmap, munmap, and brk that will report
> > > relevant addresses and sizes before each function exits successfully.
> > > 
> > > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > 
> > I don't think this is good idea. if you need syscall result, you should 
> > use syscall tracer. IOW, This tracepoint bring zero information.
> > 
> > Please see perf_event_mmap() usage. Our kernel manage adress space by
> > vm_area_struct. we need to trace it if we need to know what kernel does.
> > 
> > Thanks.
> 
> The syscall tracer does not give you the address and size of the mmaped areas
> so this does provide information above simply tracing the enter/exit points
> for each call.

Why don't you fix this?



> perf_event_mmap does provide the information for mmap calls.  Originally I sent
> a patch to add a trace point to munmap and Peter Z asked for corresponding points
> in the mmap family.  If the consensus is that the trace point in munmap is the
> only one that should be added I can resend that patch.
> 
> -- 
> Eric B Munson
> IBM Linux Technology Center
> ebmunson@us.ibm.com
> 



