Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab2CZI34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:29:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56407 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2CZI3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:29:54 -0400
Message-ID: <1332750583.16159.79.camel@twins>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Date: Mon, 26 Mar 2012 10:29:43 +0200
In-Reply-To: <20120322153205.GA28570@linux.vnet.ibm.com>
References: <1329764866.2293.376.camhel@twins>
	 <20120305152443.GE26559@linux.vnet.ibm.com>
	 <20120306091410.GD27238@elte.hu>
	 <20120322153205.GA28570@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 21:02 +0530, Srivatsa Vaddagiri wrote:
> Anyway, there are degradations as well, considering which I see
> several 
> possibilities:
> 
> 1. Do balance-on-wake for vcpu threads only.

Hell no ;-) we're not going to special case some threads over others.

> 2. Document tuning possibility to improve performance in virtualized
>    environment:
>         - Either via sched_domain flags (disable SD_WAKE_AFFINE 
>           at all levels and enable SD_BALANCE_WAKE at SMT/MC levels)

But domain flags are not exported -- except under SCHED_DEBUG and that
sysctl mess.. also SD_flags are not stable.

>         - Or via a new sched_feat(BALANCE_WAKE) tunable 

sched_feat() is not a stable ABI and shouldn't ever be used for anything
but debugging (hence it lives in debugfs and goes away if you disable
SCHED_DEBUG).


I would very much like more information on why things are a loss. Is it
really related to what cpu you pick, or is it the cost of doing the
balance thing?
