Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2GDOK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:10:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58680 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2GDOKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:10:53 -0400
Message-ID: <4FF44EE0.9040200@redhat.com>
Date: Wed, 04 Jul 2012 16:10:40 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: dlaor@redhat.com
CC: Ronen Hod <rhod@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <1340002390-3950-1-git-send-email-asias@redhat.com> <1340002390-3950-4-git-send-email-asias@redhat.com> <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com> <87zk81x7dp.fsf@rustcorp.com.au> <4FDF0DA7.40604@redhat.com> <4FF3001C.9020706@redhat.com> <4FF3017C.4020605@redhat.com>
In-Reply-To: <4FF3017C.4020605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/07/2012 16:28, Dor Laor ha scritto:
>>>> Users using a spinning disk still get IO scheduling in the host though.
>>>> What benefit is there in doing it in the guest as well?
>>>
>>> The io scheduler waits for requests to merge and thus batch IOs
>>> together. It's not important w.r.t spinning disks since the host can
>>> do it but it causes much less vmexits which is the key issue for VMs.
>>
>> Does it make sense to use the guest's I/O scheduler at all?
> 
> That's the reason we have a noop io scheduler.

But is performance really better with noop?  We had to revert usage of
QUEUE_FLAG_NONROT in the guests because it caused performance
degradation (commit f8b12e513b953aebf30f8ff7d2de9be7e024dbbe).

The bio-based path is really QUEUE_FLAG_NONROT++, so it should really be
a special case for people who know what they're doing.  (Better would be
to improve QEMU, there's definitely room for 20% improvement...).

Paolo
