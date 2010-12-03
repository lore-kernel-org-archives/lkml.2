Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0LCV0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:26:15 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43477 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab0LCV0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:26:12 -0500
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
In-Reply-To: <20101203141037.GE16411@linux.vnet.ibm.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
	 <20101202144423.3ad1908d@annuminas.surriel.com>
	 <1291382619.32004.2124.camel@laptop>
	 <20101203133056.GF27994@linux.vnet.ibm.com>
	 <1291385010.32004.2165.camel@laptop>
	 <20101203140607.GA9800@linux.vnet.ibm.com>
	 <20101203141037.GE16411@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Dec 2010 22:23:11 +0100
Message-ID: <1291411391.2032.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 19:40 +0530, Srivatsa Vaddagiri wrote:
> On Fri, Dec 03, 2010 at 07:36:07PM +0530, Srivatsa Vaddagiri wrote:
> > On Fri, Dec 03, 2010 at 03:03:30PM +0100, Peter Zijlstra wrote:
> > > No, because they do receive service (they spend some time spinning
> > > before being interrupted), so the respective vruntimes will increase, at
> > > some point they'll pass B0 and it'll get scheduled.
> > 
> > Is that sufficient to ensure that B0 receives its fair share (1/3 cpu in this
> > case)?
> 
> Hmm perhaps yes, althought at cost of tons of context switches, which would be
> nice to minimize on?

Don't care, as long as the guys calling yield_to() pay for that time its
their problem.
