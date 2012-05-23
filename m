Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab2EWJ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:58:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59495 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2EWJ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <1337762914.9698.65.camel@twins>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
	<1337754751-9018-2-git-send-email-kernelfans@gmail.com>
	<1337759644.9698.49.camel@twins>
	<CAFgQCTvhVs8-onz3huovYe=StOYJe2pJO-nka_7KogSju6AttQ@mail.gmail.com>
	<1337761402.9698.62.camel@twins>
	<CAFgQCTt+cmUWUB6GvE=Ki5ikC1P7YA_sGrvgUKKJ6c3VuqCsAg@mail.gmail.com>
	<1337762914.9698.65.camel@twins>
Date: Wed, 23 May 2012 17:58:29 +0800
Message-ID: <CAFgQCTuzuscs8piDms3t8HyBTsFSfNiVf1JcDQ=UX8PQpUiU3w@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: add virt sched domain for the guest
From: Liu ping fan <kernelfans@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 4:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-05-23 at 16:34 +0800, Liu ping fan wrote:
>> so we need to migrate some of vcpus from node-B to node-A, or to
>> node-C.
>
> This is absolutely broken, you cannot do that.
>
> A guest task might want to be node affine, it looks at the topology sets
> a cpu affinity mask and expects to stay on that node.
>
> But then you come along, and flip one of those cpus to another node. The
> guest task will now run on another node and get remote memory accesses.
>
Oh, I had thought using -smp to handle such situation. The memory
accesses cost problem can be partly handled by kvm,
while opening a gap for guest's scheduler to see the host numa info.

> Similarly for the guest kernel, it assumes cpu:node maps are static, it
> will use this for all kinds of things, including the allocation of
> per-cpu memory to be node affine to that cpu.
>
> If you go migrate cpus across nodes everything comes down.
>
>
> Please go do something else, I'll do this.

OK, thanks.
pingfan
