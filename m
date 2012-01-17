Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab2AQJ4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:56:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2AQJ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:56:08 -0500
Message-ID: <4F1545A4.3000809@redhat.com>
Date: Tue, 17 Jan 2012 10:55:48 +0100
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
References: <1326772723.2819.167.camel@deadeye> <1326773222.2819.172.camel@deadeye>
In-Reply-To: <1326773222.2819.172.camel@deadeye>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 05:07 AM, Ben Hutchings wrote:
> Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>
> [bwh: Backport to 2.6.32 - ENOIOCTLCMD does not get converted to
>   ENOTTY, so we must return ENOTTY directly]
> Signed-off-by: Ben Hutchings<ben@decadent.org.uk>

Have you tested 32-on-64?  I already did this change in the version for 
3.2 stable, but sd_compat_ioctl has to keep ENOIOCTLCMD:

> [ Cherry picked from 3ed4e7ba4be8c72051d87dcb2dec279d97a18d41
>
>   Changes with respect to 3.3: return -ENOTTY from scsi_verify_blk_ioctl
>   and -ENOIOCTLCMD from sd_compat_ioctl. ]

Paolo
