Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2GQJc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab2GQJcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:32:54 -0400
Message-ID: <5005313D.1000300@redhat.com>
Date: Tue, 17 Jul 2012 11:32:45 +0200
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
References: <1342107302-28116-1-git-send-email-asias@redhat.com> <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com> <50052276.2080906@redhat.com> <500527BA.9000001@redhat.com> <50052E7E.6020100@redhat.com>
In-Reply-To: <50052E7E.6020100@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2012 11:21, Asias He ha scritto:
>> It depends.  Like vhost-scsi, vhost-blk has the problem of a crippled
>> feature set: no support for block device formats, non-raw protocols,
>> etc.  This makes it different from vhost-net.
> 
> Data-plane qemu also has this cripppled feature set problem, no?

Yes, but that is just a proof of concept.  We can implement a separate
I/O thread within the QEMU block layer, and add fast paths that resemble
data-path QEMU, without limiting the feature set.

> Does user always choose to use block devices format like qcow2? What
> if they prefer raw image or raw block device?

If they do, the code should hit fast paths and be fast.  But it should
be automatic, without the need for extra knobs.  aio=thread vs.
aio=native is already one knob too much IMHO.

>> So it begs the question, is it going to be used in production, or just a
>> useful reference tool?
> 
> This should be decided by user, I can not speak for them. What is wrong
> with adding one option for user which they can decide?

Having to explain the user about the relative benefits; having to
support the API; having to handle transition from one more thing when
something better comes out.

Paolo
