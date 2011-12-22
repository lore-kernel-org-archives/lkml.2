Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab1LVTNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:13:14 -0500
Received: from 1wt.eu ([62.212.114.60]:44696 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab1LVTNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:13:10 -0500
Date: Thu, 22 Dec 2011 20:11:46 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
Message-ID: <20111222191146.GA21347@1wt.eu>
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com> <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:37:56AM -0800, Linus Torvalds wrote:
> On Thu, Dec 22, 2011 at 10:02 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > Linux allows executing the SG_IO ioctl on a partition or even on an
> > LVM volume, and will pass the command to the underlying block device.
> > This is well-known, but it is also a large security problem when (via
> > Unix permissions, ACLs, SELinux or a combination thereof) a program or
> > user needs to be granted access to a particular partition or logical
> > volume but not to the full device.
> 
> So who actually *does* this in practice?

I've seen this in the past when mtools were used a lot to access FAT
partitions on dual-boot systems. I've also seen it with vmware, where
a user is allowed to boot the other OS within vmware without rebooting.
But granted this is not the most common scheme.

Willy

