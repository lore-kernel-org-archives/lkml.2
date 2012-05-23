Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab2EWIeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:34:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64131 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab2EWIeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:34:04 -0400
MIME-Version: 1.0
In-Reply-To: <1337761402.9698.62.camel@twins>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
	<1337754751-9018-2-git-send-email-kernelfans@gmail.com>
	<1337759644.9698.49.camel@twins>
	<CAFgQCTvhVs8-onz3huovYe=StOYJe2pJO-nka_7KogSju6AttQ@mail.gmail.com>
	<1337761402.9698.62.camel@twins>
Date: Wed, 23 May 2012 16:34:03 +0800
Message-ID: <CAFgQCTt+cmUWUB6GvE=Ki5ikC1P7YA_sGrvgUKKJ6c3VuqCsAg@mail.gmail.com>
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

On Wed, May 23, 2012 at 4:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-05-23 at 16:10 +0800, Liu ping fan wrote:
>> the movement of vcpu
>> threads among host nodes will break the topology initialized by -numa
>> option.
>
> You want to remap vcpu to nodes? Are you bloody insane? cpu:node maps
> are assumed static, you cannot make that a dynamic map and pray things
> keep working.
>
> Also, have you any idea how expensive it is to rebuild the topology vs
> migrating the vcpu?
>
No, do not rebuild the topology too frequently. Supposing vcpus in
node-A/B/C, now node-B is unplugged,
so we need to migrate some of vcpus from node-B to node-A, or to node-C.
>
