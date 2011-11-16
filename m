Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1KPI4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:56:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41770 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1KPI4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 03:56:48 -0500
Subject: Re: [PATCH] sched: avoid unnecessary overflow in sched_clock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>, john stultz <johnstul@us.ibm.com>,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 16 Nov 2011 09:56:22 +0100
In-Reply-To: <4EC36165.3090002@google.com>
References: <20111115221121.7262.88871.stgit@dungbeetle.mtv.corp.google.com>
	  <1321398123.2352.29.camel@work-vm>
	 <1321425705.12017.1.camel@marge.simson.net> <4EC36165.3090002@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321433782.1421.71.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 23:08 -0800, Paul Turner wrote:
> Probably a good idea -- This especially sucks rocks in the sched_clock_stable==1 
> case; resulting in it coming straight back out of sched_clock_cpu() and trashing 
> rq->clock. 

There's another problem there in that TSC will wrap too soon and things
will blow up in your face that way.


