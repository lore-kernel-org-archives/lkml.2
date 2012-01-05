Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2AER04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:26:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab2AER0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:26:55 -0500
Message-ID: <4F05DD3E.9060204@redhat.com>
Date: Thu, 05 Jan 2012 18:26:22 +0100
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
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com> <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com> <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com> <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com> <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com> <20111223062649.GD21994@1wt.eu> <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com> <4EF48CE4.3000104@redhat.com> <CA+55aFy=7wGzQv76dirJ=ZjeNdbKVKDRCLA323orsE13GcKvwQ@mail.gmail.com> <4F05A332.1060600@redhat.com> <CA+55aFwcZjxZsVV_9rsKgApDfEMdCdHYvkDW5Wz7j-=gd_tFeQ@mail.gmail.com> <4F05D286.7030205@redhat.com> <CA+55aFwi2xWsmRb+kMsqJ5cq5c8WD=iPZS9WXU=9VRVaJCu2sQ@mail.gmail.com>
In-Reply-To: <CA+55aFwi2xWsmRb+kMsqJ5cq5c8WD=iPZS9WXU=9VRVaJCu2sQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 06:04 PM, Linus Torvalds wrote:
>
>> >  Foolish me who found a bug, and an exploitable one for that matter, and even
>> >  tried to fix it.  Looks like security by obscurity would have served users better.
> Umm. I just sent out what I think is what we*should*  be doing.
>
> You are the one who seems to just want to add hack upon hack to
> things. THAT is what I really hate. It's not only in bad taste, it
> *will*  come back and bite us some day.

I could have just written

+	ret = scsi_verify_blk_ioctl(bdev, cmd);
+	if (ret < 0)
+		return -ENOIOCTLCMD;

It wouldn't have been any less hacky, but it would have looked quite 
normal and perhaps it would have escaped review.  I knew I was working 
around messy code, and I made that clear.  In that, I succeeded. :)

> If you think that "security" is about adding new special cases and
> hacks, you're so out to lunch that it isn't even funny. It is
> absolutely the*last*  thing you want.

Thanks for the tip, :) and thanks for picking up the cleanup.  I'll keep 
an eye and resubmit when the dust settles.

Paolo
