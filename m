Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2GQIwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:52:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55583 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2GQIwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:52:19 -0400
Message-ID: <500527BA.9000001@redhat.com>
Date: Tue, 17 Jul 2012 10:52:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
References: <1342107302-28116-1-git-send-email-asias@redhat.com> <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com> <50052276.2080906@redhat.com>
In-Reply-To: <50052276.2080906@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2012 10:29, Asias He ha scritto:
> So, vhost-blk at least saves ~6 syscalls for us in each request. 

Are they really 6?  If I/O is coalesced by a factor of 3, for example
(i.e. each exit processes 3 requests), it's really 2 syscalls per request.

Also, is there anything we can improve?  Perhaps we can modify epoll and
ask it to clear the eventfd for us (would save 2 reads)?  Or
io_getevents (would save 1)?

> I guess you mean qemu here. Yes, in theory, qemu's block layer can be
> improved to achieve similar performance as vhost-blk or kvm tool's
> userspace virito-blk has. But I think it makes no sense to prevent one
> solution becase there is another in theory solution called: we can do
> similar in qemu.

It depends.  Like vhost-scsi, vhost-blk has the problem of a crippled
feature set: no support for block device formats, non-raw protocols,
etc.  This makes it different from vhost-net.

So it begs the question, is it going to be used in production, or just a
useful reference tool?

Paolo
