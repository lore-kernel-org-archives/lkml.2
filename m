Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1LFTPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:15:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:55829 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab1LFTMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:37 -0500
Message-ID: <1323198720.32012.84.camel@twins>
Subject: Re: [PATCH 0/3] Use jump_label for sched_feat()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Tue, 06 Dec 2011 20:12:00 +0100
In-Reply-To: <20111206181000.GE2449@redhat.com>
References: <20111206171534.429636558@chello.nl>
	 <20111206181000.GE2449@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 13:10 -0500, Jason Baron wrote:
> On Tue, Dec 06, 2011 at 06:15:34PM +0100, Peter Zijlstra wrote:
> > These patches implement sched_feat() using jump_labels. The first is a section
> > mismatch fix. The second patch provides a little infrastructure and the third
> > patch applies it to make sched_feat() use static_branch().
> > 
> > It uses static_branch() coupled with unlikely/likely in order to control the
> > branch block position. I haven't checked if it works, but it likely doesn't,
> > although it should.
> > 
> > 
> 
> It doesn't. I played around with unlikely/likely a bit, and it
> didn't seem to make a difference. 

Right, we should look at getting that fixed though.. I think its a very
useful hint to have.

> That said, jump_labels could still be
> an improvement here - it be good if we had some numbers, I guess.

Yeah, acme had some number on an older version of this patch.
