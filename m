Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0LCNbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:31:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34718 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0LCNbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:31:02 -0500
Date: Fri, 3 Dec 2010 19:00:57 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
Message-ID: <20101203133056.GF27994@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101202144423.3ad1908d@annuminas.surriel.com>
 <1291382619.32004.2124.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291382619.32004.2124.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 02:23:39PM +0100, Peter Zijlstra wrote:
> Right, so another approach might be to simply swap the vruntime between
> curr and p.

Can't that cause others to stave? For ex: consider a cpu p0 having these tasks:

p0 ->  A0 B0 A1

A0/A1 have entered some sort of AB<->BA spin-deadlock, as a result A0 wants to
direct yield to A1 which wants to direct yield to A0. If we keep swapping their
runtimes, can't it starve B0?

- vatsa


