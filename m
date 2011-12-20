Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1LTBzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:55:39 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54974 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab1LTBzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:55:37 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        paulus <paulus@samba.org>
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <1324309901.24621.14.camel@twins>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <1324309901.24621.14.camel@twins>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 20 Dec 2011 07:26:18 +0530
Message-ID: <874nww2egt.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121916-3568-0000-0000-000000E9779E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 16:51:41 +0100, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> Anyway, I had a look at your patches and I don't see how could ever
> work. You gang-schedule cgroup entities, but there's no guarantee the
> load-balancer will have at least one task for each group on every cpu.
>
As stated earlier:

    The gang scheduling problem can be broken into two parts:
    a) Placement of the tasks to be gang scheduled 
    b) Synchronized scheduling of the tasks across a subset of cpu.

In the patch, I have (b) implemented and placement is done by pinning
the vcpu of a VM in userspace. Yes, thats not the right way. 

Effectively, no trouble to the load-balancer here.

Nikunj

