Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2GQNC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab2GQNCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:02:55 -0400
Message-ID: <50056275.6000407@redhat.com>
Date: Tue, 17 Jul 2012 15:02:45 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
References: <1342107302-28116-1-git-send-email-asias@redhat.com> <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com> <50052276.2080906@redhat.com> <500527BA.9000001@redhat.com> <50052E7E.6020100@redhat.com> <CAJSP0QW0tPV3WASGOBRE4hL=8zzSFQ6T=bHbEwMAzmHR9wnwJg@mail.gmail.com> <20120717112645.GA9363@redhat.com> <CAJSP0QXPkrVvgA+1fhhwsB5J8oApOObK8D3fk_Lm0Bt3T+Wfuw@mail.gmail.com> <20120717115450.GA9796@redhat.com> <CAJSP0QXwGuUaD9piktOptJasdpci_fA90d=vV4m0SuORMvc2=Q@mail.gmail.com> <20120717124859.GA9883@redhat.com>
In-Reply-To: <20120717124859.GA9883@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2012 14:48, Michael S. Tsirkin ha scritto:
> On Tue, Jul 17, 2012 at 01:03:39PM +0100, Stefan Hajnoczi wrote:
>> On Tue, Jul 17, 2012 at 12:54 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
>>>> Knowing the answer to that is important before anyone can say whether
>>>> this approach is good or not.
>>>>
>>>> Stefan
>>>
>>> Why is it?
>>
>> Because there might be a fix to kvmtool which closes the gap.  It
>> would be embarassing if vhost-blk was pushed just because no one
>> looked into what is actually going on.
> 
> Embarrasing to whom? Is someone working on an optimization that
> makes the work in question redundant, with posting just around
> the corner? Then maybe the thing to do is just wait a bit.

Of course there is work going on to make QEMU perform better.  Not sure
about lkvm.

>> And on the flipside, hard evidence of an overhead that cannot be
>> resolved could be good reason to do more vhost devices in the future.
> 
> How can one have hard evidence of an overhead that cannot be resolved?

Since we do have two completely independent userspaces (lkvm and
data-plane QEMU), you can build up some compelling evidence of an
overhead that cannot be resolved in user space.

>> Either way, it's useful to do this before going further.
> 
> I think each work should be discussed on its own merits.  Maybe
> vhost-blk is just well written. So? What is your conclusion?

If it's just that vhost-blk is written well, my conclusion is that lkvm
people should look into improving their virtio-blk userspace.  We take
hints from each other all the time, for example virtio-scsi will have
unlocked kick in 3.6.

Why can't vhost-* just get into staging, and we call it a day?

Paolo
