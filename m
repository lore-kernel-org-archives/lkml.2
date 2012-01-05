Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801Ab2AEQln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:41:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711Ab2AEQlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:41:42 -0500
Message-ID: <4F05D286.7030205@redhat.com>
Date: Thu, 05 Jan 2012 17:40:38 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition
 devices
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com> <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com> <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com> <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com> <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com> <20111223062649.GD21994@1wt.eu> <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com> <4EF48CE4.3000104@redhat.com> <CA+55aFy=7wGzQv76dirJ=ZjeNdbKVKDRCLA323orsE13GcKvwQ@mail.gmail.com> <4F05A332.1060600@redhat.com> <CA+55aFwcZjxZsVV_9rsKgApDfEMdCdHYvkDW5Wz7j-=gd_tFeQ@mail.gmail.com>
In-Reply-To: <CA+55aFwcZjxZsVV_9rsKgApDfEMdCdHYvkDW5Wz7j-=gd_tFeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 05:16 PM, Linus Torvalds wrote:
> On Thu, Jan 5, 2012 at 5:18 AM, Paolo Bonzini<pbonzini@redhat.com>  wrote:
>>
>> Hence, changing scsi_verify_blk_ioctl to return ENOIOCTLCMD is not
>> really possible.
>
> What?
>
> "We have a bug in the block IO layer, so we cannot possible fix
> another problem?"
>
> Whjat the f*ck is the logic there?
>
> Just fix the *obvious* breakage in BLKROSET. It's clearly what the
> code *intends* to do, it just didn't check for ENOIOCTLCMD.

Aha, so this is clear and obvious.  And who knows that something else 
won't break?  Such as the 32-on-64 logic that already uses ENOIOCTLCMD 
for something else?

If the block maintainers want to fix that, fine.  "git blame 
block/ioctl.c" shows that it's been like this for 6 years and in general 
the file has hardly seen changes.  That's enough to make me steer away 
from that code.

Foolish me who found a bug, and an exploitable one for that matter, and 
even tried to fix it.  Looks like security by obscurity would have 
served users better.

Paolo
