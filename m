Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab2EWHyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:54:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56556 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab2EWHyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:54:14 -0400
Message-ID: <1337759644.9698.49.camel@twins>
Subject: Re: [PATCH 1/2] sched: add virt sched domain for the guest
From: Peter Zijlstra <peterz@infradead.org>
To: Liu Ping Fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Date: Wed, 23 May 2012 09:54:04 +0200
In-Reply-To: <1337754751-9018-2-git-send-email-kernelfans@gmail.com>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
	 <1337754751-9018-2-git-send-email-kernelfans@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 14:32 +0800, Liu Ping Fan wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> 
> The guest's scheduler can not see the numa info on the host and
> this will result to the following scene:
>   Supposing vcpu-a on nodeA, vcpu-b on nodeB, when load balance,
> the tasks' pull and push between these vcpus will cost more. But
> unfortunately, currently, the guest is just blind to this.
> 
> This patch want to export the host numa info to the guest, and help
> guest to rebuild its sched domain based on host's info.

Hell no, we're not going to export sched domains, if kvm/qemu wants this
its all in sysfs.

The whole sched_domain stuff is a big enough pain as it is, exporting
this and making it a sodding API is the worst thing ever. 

Whatever brainfart made you think this is needed anyway? sysfs contains
the host topology, qemu can already create whatever guest topology you
want (see the -smp and -numa arguments), so what gives?
