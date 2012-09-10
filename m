Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2IJFvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 01:51:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33244 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2IJFvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 01:51:47 -0400
Message-ID: <504D7FEE.20008@redhat.com>
Date: Mon, 10 Sep 2012 07:51:42 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, yvugenfi@redhat.com,
        linux-kernel@vger.kernel.org, mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
References: <50486BB2.7070108@redhat.com> <20120906094442.GA22816@redhat.com> <50487382.8030303@redhat.com> <20120906105301.GC32325@redhat.com> <5048935A.8090308@redhat.com> <87wr06hg0l.fsf@rustcorp.com.au> <20120907054202.GA3452@redhat.com> <87vcfqfia1.fsf@rustcorp.com.au> <20120907104306.GA17211@redhat.com> <87sjatf6iv.fsf@rustcorp.com.au> <20120908223724.GB20588@redhat.com> <87fw6qfya7.fsf@rustcorp.com.au>
In-Reply-To: <87fw6qfya7.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/09/2012 03:43, Rusty Russell ha scritto:
>> Now that vfio is upstream and work on qemu integration
>> is being worked on, we might finally see people using this bit
>> to allow memory overcommit with device assignment.
> That was left-field.... so you're saying some guest might pull a page
> from the balloon and DMA to it, and the vfio device needs to know in
> advance that it's going to do it?

Not the vfio device, but the page needs to be pinned with mlock so the
effect is the same.

> But what will we do if the guest doesn't ack the bit?

Just pin the whole memory.

Paolo

> ie. I don't think it can really be optional.

