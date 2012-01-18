Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2ARJBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:01:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab2ARJBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:01:16 -0500
Message-ID: <4F168A49.8000606@redhat.com>
Date: Wed, 18 Jan 2012 10:00:57 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH stable 3/4] block: fail SCSI passthrough ioctls on partition
 devices
References: <1326772723.2819.167.camel@deadeye>  <1326773222.2819.172.camel@deadeye> <4F1545A4.3000809@redhat.com> <1326862077.2819.210.camel@deadeye>
In-Reply-To: <1326862077.2819.210.camel@deadeye>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 05:47 AM, Ben Hutchings wrote:
> >     Changes with respect to 3.3: return -ENOTTY from scsi_verify_blk_ioctl
> >     and -ENOIOCTLCMD from sd_compat_ioctl. ]
>
> But in 2.6.32, compat_sys_ioctl will end up returning EINVAL rather than
> ENOTTY for an unhandled ioctl number.

No, it won't.  The ioctl will percolate up the non-compat path and then 
sd_ioctl will return ENOTTY.

> Also, since we're denying ioctls
> for security reasons rather than because we don't know how to handle
> them, I don't think there's any harm in doing this.

There is harm.  You'll be blacklisting also the standard block device 
ioctls, and those won't work on 32-on-64 anymore.  A system with 32-bit 
userland will likely not boot anymore.  This is also somewhat exchanged 
in my original exchange with Linus.

Paolo
