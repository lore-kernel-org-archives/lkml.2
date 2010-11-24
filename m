Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0KXQPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 11:15:06 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:46734 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751443Ab0KXQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 11:15:04 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: eZMVm7UVM1nXrZ8nR_JxfthXHyJO1UoWUUqkxABTO2L39yd
 GtKjlymZpI7VWjX_j1slZvVWmjlcogwqNJsozEh4.CpvCn18__LiicwgVnrL
 Pa4t742T15Z2rHeVHHYKc.7EheFZ23PTHR6vVtI50LJ5kKOfVsSCF2_YarOK
 YS3_qaEwkl7FNCvI7v5rYv4IRm2s7BQIgF4RoCGOI_ZMcyJpH_vY9OVd.J9Q
 yJ8ZJYkkxcsYBNlRL1D.Hnu531ZkJUB_a7zuMg0c-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 24 Nov 2010 10:14:58 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
In-Reply-To: <1290586512.2072.423.camel@laptop>
Message-ID: <alpine.DEB.2.00.1011241013240.14268@router.home>
References: <20101123235139.908255844@linux.com>  <20101123235201.758191189@linux.com> <1290586512.2072.423.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Peter Zijlstra wrote:

> This thing still relies on disabling IRQs in the slow path, which means
> its still going to be a lot of work to make it work on -rt.

The disabling of irqs is because slab operations are used from interrupt
context. If we can avoid slab operations from interrupt contexts then we
can drop the interrupt disable in the slab allocators.

