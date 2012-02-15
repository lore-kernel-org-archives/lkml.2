Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2BOR0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:26:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49278 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2BOR0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:26:42 -0500
Message-ID: <1329326787.2293.153.camel@twins>
Subject: Re: sched: Performance of Trade workload running inside VM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Date: Wed, 15 Feb 2012 18:26:27 +0100
In-Reply-To: <20120215171032.GB9918@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
	 <1329307161.2293.66.camel@twins> <20120215171032.GB9918@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 22:40 +0530, Srivatsa Vaddagiri wrote:
> Isn't it already broken in some respect, given that
> select_idle_sibling() could select a cpu which is different from
> wakeup
> source (thus forcing a task to run on a cpu different from wakeup
> source)? 

select_idle_sibling() should keep it in the same cache domain, thereby
reducing pain and increasing parallelism.
