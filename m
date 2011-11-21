Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1KUVm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:42:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:51827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1KUVm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:42:26 -0500
Message-ID: <1321911730.28118.35.camel@twins>
Subject: Re: [tip:perf/urgent] perf/x86: Enable raw event access to Intel
 offcore events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Date: Mon, 21 Nov 2011 22:42:10 +0100
In-Reply-To: <CABPqkBTfNuY8_rcf-u=kf4V-bv_bZwUAhz3J3Z=wan29=09f9A@mail.gmail.com>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
	 <tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org>
	 <alpine.DEB.2.00.1111211321390.21667@cl320.eecs.utk.edu>
	 <1321901536.28118.20.camel@twins>
	 <alpine.DEB.2.00.1111211358570.23676@cl320.eecs.utk.edu>
	 <CABPqkBRHW0ZmeqADptvBySLZpi6jc_bEFKoukkA6rtd5o04ziQ@mail.gmail.com>
	 <alpine.DEB.2.00.1111211559190.24943@cl320.eecs.utk.edu>
	 <CABPqkBTfNuY8_rcf-u=kf4V-bv_bZwUAhz3J3Z=wan29=09f9A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 22:39 +0100, Stephane Eranian wrote:
> To solve this problem (in the general case), you need to know which
> counter is taken (or required)
> by ALL pinned system-wide events across all CPUs. Once you've
> constructed the bitmap, you can
> use it as the basis (used_mask) to try and schedule the group events.
> 
Its worse, you also need to consider all task-pinned events if you want
to be complete. That's an even worse problem.
