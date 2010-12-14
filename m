Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab0LNJZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:25:41 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51050 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab0LNJZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:25:39 -0500
Date: Tue, 14 Dec 2010 14:55:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Subject: Re: [RFC PATCH 0/3] directed yield for Pause Loop Exiting
Message-ID: <20101214092535.GD14178@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101210050344.GR3158@balbir.in.ibm.com>
 <4D0328CC.1020809@redhat.com>
 <20101211135727.GU3158@balbir.in.ibm.com>
 <4D0651BB.9040609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D0651BB.9040609@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2010-12-13 12:02:51]:

> On 12/11/2010 08:57 AM, Balbir Singh wrote:
> 
> >If the vpcu holding the lock runs more and capped, the timeslice
> >transfer is a heuristic that will not help.
> 
> That indicates you really need the cap to be per guest, and
> not per VCPU.
>

Yes, I personally think so too, but I suspect there needs to be a
larger agreement on the semantics. The VCPU semantics in terms of
power apply to each VCPU as opposed to the entire system (per guest).
 
> Having one VCPU spin on a lock (and achieve nothing), because
> the other one cannot give up the lock due to hitting its CPU
> cap could lead to showstoppingly bad performance.

Yes, that seems right!

-- 
	Three Cheers,
	Balbir
