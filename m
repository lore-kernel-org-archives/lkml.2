Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab1ADGOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:14:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36990 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1ADGO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:14:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
Cc: kosaki.motohiro@jp.fujitsu.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20110103162918.577a9620@annuminas.surriel.com>
References: <20110103162637.29f23c40@annuminas.surriel.com> <20110103162918.577a9620@annuminas.surriel.com>
Message-Id: <20110104151345.3BC2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  4 Jan 2011 15:14:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mike Galbraith <efault@gmx.de>
> 
> Add a yield_to function to the scheduler code, allowing us to
> give enough of our timeslice to another thread to allow it to
> run and release whatever resource we need it to release.
> 
> We may want to use this to provide a sys_yield_to system call
> one day.

At least I want. Ruby has GIL(giant interpreter lock). And giant lock
naturally enforce an app to implement cooperative multithreading model.
Therefore it has similar problem with your one. Python solved this issue
by slowing lock mechanism (two pthread-cond wakeup each GIL releasing), 
but I don't want it.

Also, If pthread_cond_signal() call sys_yield_to imlicitly, we can
avoid almost Nehalem (and other P2P cache arch) lock unfairness 
problem. (probaby creating pthread_condattr_setautoyield_np or similar
knob is good one)



