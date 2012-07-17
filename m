Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab2GQLgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 07:36:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56774 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2GQLgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 07:36:35 -0400
MIME-Version: 1.0
In-Reply-To: <50052276.2080906@redhat.com>
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
	<CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com>
	<50052276.2080906@redhat.com>
Date: Tue, 17 Jul 2012 12:36:32 +0100
Message-ID: <CAJSP0QX4VqP+_YdfrqHtK5GrB+c8xmziBr=k9PE1WeyWWH_cgQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add vhost-blk support
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 9:29 AM, Asias He <asias@redhat.com> wrote:
> On 07/16/2012 07:58 PM, Stefan Hajnoczi wrote:
>> Does the vhost-blk implementation do anything fundamentally different
>> from userspace?  Where is the overhead that userspace virtio-blk has?
>
>
>
> Currently, no. But we could play with bio directly in vhost-blk as Christoph
> suggested which could make the IO path from guest to host's real storage
> even shorter in vhost-blk.

Wait :).  My point is that writing new code without systematically
investigating performance means that we're essentially throwing random
things and seeing what sticks.

Adding bio mode would make vhost-blk and kvmtool more different.
It'll probably make vhost-blk slightly faster but harder to compare
against kvmtool.  It's easier to start profiling before making that
change.

The reason I said "special-purpose kernel module" is because kvmtool
could be suffering from a bottleneck that can be fixed.  Other
userspace applications would also benefit from that fix - it would be
generally useful.  Adding a vhost-blk kernel module works around this
but only benefits KVM specifically.

Stefan
