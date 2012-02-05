Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2BEWpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:45:11 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54019 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2BEWpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:45:04 -0500
Message-ID: <4F2F0669.3000601@redhat.com>
Date: Sun, 05 Feb 2012 23:44:57 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.stable,gmane.linux.scsi
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 90/91] block: fail SCSI passthrough ioctls on partition
 devices
References: <0635750f5f06ed2ca212b91fcb5c4483@local> <20120205220953.312427771@pcw.home.local>
In-Reply-To: <20120205220953.312427771@pcw.home.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 11:11 PM, Willy Tarreau wrote:
> Signed-off-by: Ben Hutchings<ben@decadent.org.uk>
> Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> [wt: no scsi_cmd_blk_ioctl in 2.6.27, change callers instead. cciss is OK,
>   ub,virtio_blk,ide-floppy,sd need fixing, cdrom&st can be ignored ]

NACK, you aren't fixing virtio-blk to call scsi_verify_blk_ioctl, are you?

You need to backport the patch that introduced scsi_cmd_blk_ioctl, 
which, in fact was in the same patch series as this one.

Paolo
