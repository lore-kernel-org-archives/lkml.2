Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2EWIss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:48:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37873 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2EWIsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:48:45 -0400
Message-ID: <1337762914.9698.65.camel@twins>
Subject: Re: [PATCH 1/2] sched: add virt sched domain for the guest
From: Peter Zijlstra <peterz@infradead.org>
To: Liu ping fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Date: Wed, 23 May 2012 10:48:34 +0200
In-Reply-To: <CAFgQCTt+cmUWUB6GvE=Ki5ikC1P7YA_sGrvgUKKJ6c3VuqCsAg@mail.gmail.com>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
	 <1337754751-9018-2-git-send-email-kernelfans@gmail.com>
	 <1337759644.9698.49.camel@twins>
	 <CAFgQCTvhVs8-onz3huovYe=StOYJe2pJO-nka_7KogSju6AttQ@mail.gmail.com>
	 <1337761402.9698.62.camel@twins>
	 <CAFgQCTt+cmUWUB6GvE=Ki5ikC1P7YA_sGrvgUKKJ6c3VuqCsAg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 16:34 +0800, Liu ping fan wrote:
> so we need to migrate some of vcpus from node-B to node-A, or to
> node-C.

This is absolutely broken, you cannot do that.

A guest task might want to be node affine, it looks at the topology sets
a cpu affinity mask and expects to stay on that node.

But then you come along, and flip one of those cpus to another node. The
guest task will now run on another node and get remote memory accesses.

Similarly for the guest kernel, it assumes cpu:node maps are static, it
will use this for all kinds of things, including the allocation of
per-cpu memory to be node affine to that cpu.

If you go migrate cpus across nodes everything comes down.


Please go do something else, I'll do this.
